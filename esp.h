#pragma once
#include "mem.h"
#include <thread>
#include <vector>

struct vec3{float x,y,z; vec3(){}vec3(float a,float b,float c):x(a),y(b),z(c){}
    float dist(const vec3&o)const{float a=x-o.x,b=y-o.y,c=z-o.z;return sqrtf(a*a+b*b+c*c);}
    bool zero()const{return x==0&&y==0&&z==0;} bool sane()const{return std::isfinite(x)&&std::isfinite(y)&&std::isfinite(z)&&fabsf(x)<100000&&fabsf(y)<100000&&fabsf(z)<100000;}};
struct mat4{float m[16];};

inline bool W2S(const vec3&p,const mat4&v,float w,float h,vec3&o){
    float cx=p.x*v.m[0]+p.y*v.m[4]+p.z*v.m[8]+v.m[12], cy=p.x*v.m[1]+p.y*v.m[5]+p.z*v.m[9]+v.m[13], cw=p.x*v.m[3]+p.y*v.m[7]+p.z*v.m[11]+v.m[15];
    if(cw<0.01f)return false; o.x=(w*.5f)*(cx/cw)+(w*.5f); o.y=-(h*.5f)*(cy/cw)+(h*.5f); o.z=cw;
    return std::isfinite(o.x)&&std::isfinite(o.y);
}
static const int CONN[][2]={{0,1},{1,2},{1,3},{3,4},{4,5},{1,6},{6,7},{7,8},{2,9},{9,10},{10,11},{11,12},{2,13},{13,14},{14,15},{15,16}};
static const vec3 REFPOSE[17]={{0.005f,0.154f,1.602f},{-0.05f,-0.044f,1.354f},{-0.129f,-0.139f,0.955f},
 {-0.223f,0.035f,1.345f},{-0.344f,0.132f,1.066f},{-0.139f,0.362f,1.105f},{0.084f,-0.146f,1.389f},
 {0.224f,-0.151f,1.09f},{0.181f,0.166f,1.046f},{-0.202f,-0.142f,0.884f},{-0.197f,0.197f,0.558f},
 {-0.295f,0.128f,0.301f},{-0.341f,0.058f,0.065f},{-0.075f,-0.204f,0.904f},{0.21f,-0.094f,0.524f},
 {0.206f,-0.254f,0.314f},{0.182f,-0.408f,0.076f}};

struct Offsets{uintptr_t entityList=0,localPlayer=0,viewMatrix=0;bool ok=false;};
struct Player{vec3 head,feet;vec3 bones[17];bool boneOk[17]{};float health=100,distance=0;
              bool enemy=true,valid=false;int stance=0;wchar_t name[32]{};};

extern std::vector<Player> g_players; extern std::mutex g_playersMtx;
extern std::atomic<bool> g_running, g_gameFound;
extern Offsets g_off; extern wchar_t g_status[256];
extern std::vector<BYTE> g_modImage; extern std::mutex g_modMtx;

inline uintptr_t PatternScan(const BYTE*d,size_t len,const std::string&sig){
    std::vector<int> pat; std::vector<char> wild;
    for(size_t i=0;i<sig.size();){ if(sig[i]==' '){i++;continue;} if(sig[i]=='?'){pat.push_back(0);wild.push_back(1);i++;}
        else{pat.push_back((int)strtol(sig.substr(i,2).c_str(),0,16));wild.push_back(0);i+=2;} }
    if(pat.empty()||len<pat.size())return 0; size_t n=pat.size();
    for(size_t i=0;i+n<=len;i++){bool ok=true;for(size_t j=0;j<n;j++)if(!wild[j]&&d[i+j]!=(BYTE)pat[j]){ok=false;break;}if(ok)return i;}
    return 0;
}
inline uintptr_t ResolveMov(const std::string&sig,uintptr_t base,const BYTE*img,size_t len){
    if(sig.empty())return 0; size_t o=PatternScan(img,len,sig); if(!o||o+7>len)return 0;
    int32_t d=*(int32_t*)(img+o+3); return g_mem->Ptr(base+o+7+d);
}
inline uintptr_t WalkChain(uintptr_t b,const std::vector<uint64_t>&c){uintptr_t a=b;for(uint64_t o:c){a=g_mem->Ptr(a);if(!a)return 0;a+=(uintptr_t)o;}return a;}

struct BoneCtx{ uintptr_t skelComp=0; uint64_t boneArray=0; bool found=false; };
inline std::vector<uint16_t> SkelTags(){ std::vector<uint16_t> v; for(int x:ParseInts(g_cfg.skeletonTags)) v.push_back((uint16_t)x); return v; }

inline bool FindSkeleton(uintptr_t actor, BoneCtx& out){
    uintptr_t comps=g_mem->Ptr(actor+g_cfg.componentsOffset);
    if(!comps)return false;
    auto tags=SkelTags();
    for(int i=0;i<400;i++){
        uintptr_t c=g_mem->Ptr(comps+i*8);
        if(c<0x10000||c>0x7FFFFFFFFFFFULL)continue;
        uint16_t id=g_mem->Rd<uint16_t>(c-8);
        for(auto t:tags) if(id==t){out.skelComp=c;out.found=true;return true;}
    }
    return false;
}
inline int ScoreBoneArray(uint64_t arr){
    int good=0;
    for(int b=0;b<g_cfg.boneScanCount;b++){
        vec3 p=g_mem->Rd<vec3>(arr+(uint64_t)b*g_cfg.boneStride+g_cfg.bonePosOffset);
        float f=g_mem->Rd<float>(arr+(uint64_t)b*g_cfg.boneStride+g_cfg.boneFlagOffset);
        if(f>0.5f&&f<1.5f&&fabsf(p.x)<10&&fabsf(p.y)<10&&fabsf(p.z)<10)good++;
    }
    return good;
}
inline uint64_t DiscoverBoneArray(uintptr_t skelComp){
    uint64_t best=0; int bestScore=0;
    for(uint64_t off=0;off<0x1200;off+=8){
        uint64_t a=g_mem->Ptr(skelComp+off);
        if(a<0x10000||a>0x7FFFFFFFFFFFULL)continue;
        int s=ScoreBoneArray(a);
        if(s>bestScore){bestScore=s;best=a;}
    }
    Log(L"[bones] auto-discover: best boneArray=0x%llX score=%d",(unsigned long long)best,bestScore);
    return bestScore>=8?best:0;
}