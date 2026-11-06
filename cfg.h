#pragma once
#include <windows.h>
#include <string>
#include <vector>
#include <cstdio>
#include <cstdlib>
#include <cstdint>

struct Config {
    int  menuKey = VK_INSERT;
    int  transportMode = 0;          // 0 auto | 1 rpm | 2 kernel
    int  overlayMode   = 1;          // 1 directcomposition | 0 color-key
    std::wstring process = L"RainbowSix.exe";
    std::wstring driver  = L"iqvw64e.sys";

    bool  espEnabled=true, drawBox=false, drawCorner=false, drawName=false,
          drawDistance=false, drawHealth=true, drawTeamColor=false,
          drawSnapline=false, drawHeadDot=true, drawSkeleton=true,
          useRealBones=true, drawStance=false;
    float maxDistance = 200.f;
    int   enemyCol[3]={255,60,60}, teamCol[3]={60,200,255},
          headDotCol[3]={255,255,0}, skelCol[3]={0,255,120}, boxCol[3]={255,255,255};

    std::string sigGameManager = "48 8B 0D ? ? ? ? BA ? ? ? ? 48 03 57 ?";
    std::string sigRenderer    = "";
    uint64_t fallbackGameManager = 0x05EDEE60, fallbackRenderer = 0x05ED29A8;

    std::vector<uint64_t> chainEntityList={0x0,0xA28,0x68,0x0}, chainEntitySlot={0x60,0xD8,0x68,0x0},
                          chainLocalPlayer={0x918,0xCD0,0x0}, chainViewMatrix={0x918,0xCD0,0x140};

    uint64_t entitySize=0x40, entityListGap=0xA0, headPosOffset=0xA0, healthOffset=0x1A0,
             nameOffset=0x158, teamOffset=0x0, localHeadOffset=0x120;
    int      maxEntities=80;

    uint64_t componentsOffset = 0xC8;
    std::string skeletonTags  = "0x333,0x332,0x343,0x342,0x313";
    uint64_t boneArrayOffset  = 0x0;
    uint64_t boneStride       = 0x40;
    uint64_t bonePosOffset    = 0x30;
    uint64_t boneFlagOffset   = 0x3C;
    int      boneScanCount    = 160;
    int      boneRotMode      = 1;
    int boneIdx[17] = {0,7,28,6,5,3,12,10,9,23,20,21,19,29,26,27,25};
    bool boneLocal = true;
};
extern Config g_cfg;
extern std::wstring g_dir;
extern void Log(const wchar_t* fmt, ...);

inline std::string Trim(std::string s){ while(!s.empty()&&(s.back()=='\r'||s.back()=='\n'||s.back()==' '||s.back()=='\t'))s.pop_back(); size_t i=0; while(i<s.size()&&(s[i]==' '||s[i]=='\t'))i++; return s.substr(i); }
inline std::string ToStr(const std::wstring& w){ if(w.empty())return{}; int n=WideCharToMultiByte(CP_UTF8,0,w.c_str(),(int)w.size(),0,0,0,0); std::string s(n,0); WideCharToMultiByte(CP_UTF8,0,w.c_str(),(int)w.size(),&s[0],n,0,0); return s; }
inline std::wstring ToW(const std::string& s){ if(s.empty())return{}; int n=MultiByteToWideChar(CP_UTF8,0,s.c_str(),(int)s.size(),0,0); std::wstring w(n,0); MultiByteToWideChar(CP_UTF8,0,s.c_str(),(int)s.size(),&w[0],n); return w; }
inline std::vector<uint64_t> ParseChain(const std::string& s){ std::vector<uint64_t> v; size_t p=0; while(p<s.size()){ size_t c=s.find(',',p); std::string t=Trim(s.substr(p,c==std::string::npos?std::string::npos:c-p)); if(!t.empty())v.push_back(_strtoui64(t.c_str(),0,16)); if(c==std::string::npos)break; p=c+1;} return v; }
inline std::string ChainStr(const std::vector<uint64_t>& v){ std::string s; char b[32]; for(size_t i=0;i<v.size();++i){ sprintf_s(b,"0x%llX",(unsigned long long)v[i]); if(i)s+=","; s+=b;} return s; }
inline std::vector<int> ParseInts(const std::string& s){ std::vector<int> v; size_t p=0; while(p<s.size()){ size_t c=s.find(',',p); std::string t=Trim(s.substr(p,c==std::string::npos?std::string::npos:c-p)); if(!t.empty())v.push_back((int)strtol(t.c_str(),0,16)); if(c==std::string::npos)break; p=c+1;} return v; }

inline void SaveConfig(){
    std::wstring path = g_dir + L"r6esp.ini"; FILE* f=nullptr; _wfopen_s(&f,path.c_str(),L"w"); if(!f)return;
    fprintf(f,"[General]\nMenuKey=%d\nTransport=%d\nOverlayMode=%d\nProcess=%s\nDriver=%s\n\n"
        "[Features]\nEspEnabled=%d\nDrawBox=%d\nDrawCorner=%d\nDrawName=%d\nDrawDistance=%d\n"
        "DrawHealth=%d\nDrawTeamColor=%d\nDrawSnapline=%d\nDrawHeadDot=%d\nDrawSkeleton=%d\n"
        "UseRealBones=%d\nDrawStance=%d\nMaxDistance=%.1f\n\n"
        "[Colors]\nEnemy=%d,%d,%d\nTeam=%d,%d,%d\nHeadDot=%d,%d,%d\nSkeleton=%d,%d,%d\nBox=%d,%d,%d\n\n"
        "[Sigs]\nGameManager=%s\nRenderer=%s\n\n[Fallback]\nGameManager=0x%llX\nRenderer=0x%llX\n\n"
        "[Chains]\nEntityList=%s\nEntitySlot=%s\nLocalPlayer=%s\nViewMatrix=%s\n\n"
        "[Layout]\nEntitySize=0x%llX\nEntityListGap=0x%llX\nHeadPos=0x%llX\nHealth=0x%llX\nName=0x%llX\n"
        "Team=0x%llX\nLocalHead=0x%llX\nMaxEntities=%d\n\n"
        "[Bones]\nComponents=0x%llX\nSkeletonTags=%s\nBoneArray=0x%llX\nBoneStride=0x%llX\n"
        "BonePos=0x%llX\nBoneFlag=0x%llX\nBoneScanCount=%d\nBoneRotMode=%d\nBoneLocal=%d\n",
        g_cfg.menuKey,g_cfg.transportMode,g_cfg.overlayMode,ToStr(g_cfg.process).c_str(),ToStr(g_cfg.driver).c_str(),
        g_cfg.espEnabled,g_cfg.drawBox,g_cfg.drawCorner,g_cfg.drawName,g_cfg.drawDistance,g_cfg.drawHealth,
        g_cfg.drawTeamColor,g_cfg.drawSnapline,g_cfg.drawHeadDot,g_cfg.drawSkeleton,g_cfg.useRealBones,
        g_cfg.drawStance,g_cfg.maxDistance,
        g_cfg.enemyCol[0],g_cfg.enemyCol[1],g_cfg.enemyCol[2],g_cfg.teamCol[0],g_cfg.teamCol[1],g_cfg.teamCol[2],
        g_cfg.headDotCol[0],g_cfg.headDotCol[1],g_cfg.headDotCol[2],g_cfg.skelCol[0],g_cfg.skelCol[1],g_cfg.skelCol[2],
        g_cfg.boxCol[0],g_cfg.boxCol[1],g_cfg.boxCol[2],
        g_cfg.sigGameManager.c_str(),g_cfg.sigRenderer.c_str(),
        (unsigned long long)g_cfg.fallbackGameManager,(unsigned long long)g_cfg.fallbackRenderer,
        ChainStr(g_cfg.chainEntityList).c_str(),ChainStr(g_cfg.chainEntitySlot).c_str(),
        ChainStr(g_cfg.chainLocalPlayer).c_str(),ChainStr(g_cfg.chainViewMatrix).c_str(),
        (unsigned long long)g_cfg.entitySize,(unsigned long long)g_cfg.entityListGap,
        (unsigned long long)g_cfg.headPosOffset,(unsigned long long)g_cfg.healthOffset,
        (unsigned long long)g_cfg.nameOffset,(unsigned long long)g_cfg.teamOffset,
        (unsigned long long)g_cfg.localHeadOffset,g_cfg.maxEntities,
        (unsigned long long)g_cfg.componentsOffset,g_cfg.skeletonTags.c_str(),
        (unsigned long long)g_cfg.boneArrayOffset,(unsigned long long)g_cfg.boneStride,
        (unsigned long long)g_cfg.bonePosOffset,(unsigned long long)g_cfg.boneFlagOffset,
        g_cfg.boneScanCount,g_cfg.boneRotMode,(int)g_cfg.boneLocal);
    fclose(f);
}
inline void LoadConfig(){
    std::wstring path=g_dir+L"r6esp.ini"; FILE* f=nullptr; _wfopen_s(&f,path.c_str(),L"r"); if(!f){SaveConfig();return;}
    char line[512]; std::string sec;
    while(fgets(line,sizeof(line),f)){
        std::string s=Trim(line); if(s.empty()||s[0]==';'||s[0]=='#')continue;
        if(s[0]=='['){sec=s;continue;}
        size_t eq=s.find('='); if(eq==std::string::npos)continue;
        std::string k=Trim(s.substr(0,eq)), v=Trim(s.substr(eq+1));
        auto iv=[&]{return atoi(v.c_str());}; auto bv=[&]{return v=="1"||v=="true";};
        auto hv=[&]{return(uint64_t)_strtoui64(v.c_str(),0,16);};
        auto rgb=[&](int c[3]){sscanf_s(v.c_str(),"%d,%d,%d",&c[0],&c[1],&c[2]);};
        if(sec=="[General]"){ if(k=="MenuKey")g_cfg.menuKey=iv(); else if(k=="Transport")g_cfg.transportMode=iv();
            else if(k=="OverlayMode")g_cfg.overlayMode=iv(); else if(k=="Process")g_cfg.process=ToW(v); else if(k=="Driver")g_cfg.driver=ToW(v);}
        else if(sec=="[Features]"){ if(k=="EspEnabled")g_cfg.espEnabled=bv(); else if(k=="DrawBox")g_cfg.drawBox=bv();
            else if(k=="DrawCorner")g_cfg.drawCorner=bv(); else if(k=="DrawName")g_cfg.drawName=bv();
            else if(k=="DrawDistance")g_cfg.drawDistance=bv(); else if(k=="DrawHealth")g_cfg.drawHealth=bv();
            else if(k=="DrawTeamColor")g_cfg.drawTeamColor=bv(); else if(k=="DrawSnapline")g_cfg.drawSnapline=bv();
            else if(k=="DrawHeadDot")g_cfg.drawHeadDot=bv(); else if(k=="DrawSkeleton")g_cfg.drawSkeleton=bv();
            else if(k=="UseRealBones")g_cfg.useRealBones=bv(); else if(k=="DrawStance")g_cfg.drawStance=bv();
            else if(k=="MaxDistance")g_cfg.maxDistance=(float)atof(v.c_str());}
        else if(sec=="[Colors]"){ if(k=="Enemy")rgb(g_cfg.enemyCol); else if(k=="Team")rgb(g_cfg.teamCol);
            else if(k=="HeadDot")rgb(g_cfg.headDotCol); else if(k=="Skeleton")rgb(g_cfg.skelCol); else if(k=="Box")rgb(g_cfg.boxCol);}
        else if(sec=="[Sigs]"){ if(k=="GameManager")g_cfg.sigGameManager=v; else if(k=="Renderer")g_cfg.sigRenderer=v;}
        else if(sec=="[Fallback]"){ if(k=="GameManager")g_cfg.fallbackGameManager=hv(); else if(k=="Renderer")g_cfg.fallbackRenderer=hv();}
        else if(sec=="[Chains]"){ if(k=="EntityList")g_cfg.chainEntityList=ParseChain(v); else if(k=="EntitySlot")g_cfg.chainEntitySlot=ParseChain(v);
            else if(k=="LocalPlayer")g_cfg.chainLocalPlayer=ParseChain(v); else if(k=="ViewMatrix")g_cfg.chainViewMatrix=ParseChain(v);}
        else if(sec=="[Layout]"){ if(k=="EntitySize")g_cfg.entitySize=hv(); else if(k=="EntityListGap")g_cfg.entityListGap=hv();
            else if(k=="HeadPos")g_cfg.headPosOffset=hv(); else if(k=="Health")g_cfg.healthOffset=hv();
            else if(k=="Name")g_cfg.nameOffset=hv(); else if(k=="Team")g_cfg.teamOffset=hv();
            else if(k=="LocalHead")g_cfg.localHeadOffset=hv(); else if(k=="MaxEntities")g_cfg.maxEntities=iv();}
        else if(sec=="[Bones]"){ if(k=="Components")g_cfg.componentsOffset=hv(); else if(k=="SkeletonTags")g_cfg.skeletonTags=v;
            else if(k=="BoneArray")g_cfg.boneArrayOffset=hv(); else if(k=="BoneStride")g_cfg.boneStride=hv();
            else if(k=="BonePos")g_cfg.bonePosOffset=hv(); else if(k=="BoneFlag")g_cfg.boneFlagOffset=hv();
            else if(k=="BoneScanCount")g_cfg.boneScanCount=iv(); else if(k=="BoneRotMode")g_cfg.boneRotMode=iv();
            else if(k=="BoneLocal")g_cfg.boneLocal=bv();}
    }
    fclose(f);
}