# Noor VPN — Full Setup Guide

Isme poora code ready hai (UI, animations, AdMob wiring, WireGuard integration point). Ye guide un 5 steps ko cover karta hai jo AAPKE khud ke accounts se karne honge — ye main directly nahi kar sakta kyunki inme aapki personal credentials/payment/OTP lagti hai.

---

## Step 1 — GitHub pe code upload karo
1. github.com pe free account banao (agar nahi hai)
2. Naya repo banao: `noor-vpn`
3. Ye poora `noor_vpn/` folder us repo me upload karo (GitHub app se mobile se bhi ho jaata hai — "Add file → Upload files")

## Step 2 — VPN Server (Oracle Cloud Free Tier)
Ye asli VPN backend hai — bina iske app sirf UI demo hai.
1. oracle.com/cloud/free pe account banao (card verification lagta hai but charge nahi hota free tier ke liye)
2. Ek "Always Free" VM instance banao (Ubuntu, Frankfurt/UAE-nearby region choose karo)
3. Us VM pe SSH se WireGuard install karo:
   ```
   sudo apt update && sudo apt install wireguard -y
   ```
4. Server keys generate karo aur `/etc/wireguard/wg0.conf` setup karo (WireGuard official quickstart follow karo: wireguard.com/quickstart)
5. Har user/device ke liye ek client config generate hoga — ye hi text `vpn_service.dart` ke `fetchConfig()` se return hona chahiye

*(Agar ye technical lage, "WireGuard Oracle Cloud setup" search karke koi bhi step-by-step YouTube guide follow kar sakte ho — process same rahega)*

## Step 3 — Config delivery API (chhota backend)
App ko config file dene ke liye ek chhota API chahiye (Node.js/Python — Oracle VM pe hi chala sakte ho, ya free tier pe Render.com/Railway.app use karo). Ye API:
- User request karta hai `/config/ae-1`
- Server nayi WireGuard client key pair banata hai us user ke liye
- `.conf` text response me deta hai
`lib/services/vpn_service.dart` ke `fetchConfig()` me `http.get()` call laga do jab ye ready ho.

## Step 4 — WireGuard Flutter plugin native setup
`wireguard_flutter` package ko kaam karne ke liye Android side pe kuch native files chahiye. Package ke official GitHub README (pub.dev/packages/wireguard_flutter) me "Android setup" section follow karo — isme `build.gradle` me ek dependency add karni hoti hai. Codemagic build se pehle ye zaroor kar lena.

## Step 5 — AdMob (real ad units)
1. admob.google.com pe account banao, apna app add karo
2. Banner, Interstitial, Rewarded — teeno ad units banao
3. `lib/services/ad_service.dart` me test IDs ko apne real IDs se replace karo
4. `AndroidManifest.xml` me bhi apna real AdMob App ID daalo
5. **Publish se pehle test IDs hatana mandatory hai — warna AdMob account suspend ho sakta hai**

## Step 6 — Build APK/AAB via Codemagic (mobile se)
1. codemagic.io pe GitHub se sign up karo (free tier available)
2. Apna `noor-vpn` repo connect karo
3. "Flutter App" workflow choose karo, build type: **App Bundle (.aab)** — Play Store ko yahi chahiye
4. Signing: Codemagic khud ek signing keystore generate kar sakta hai (App settings → Code signing → Android)
5. Build start karo — 10-15 min me `.aab` file mil jaayegi, mobile pe hi download

## Step 7 — Play Console (Play Store me publish)
1. Play Console (free — one-time $25 registration fee lagti hai, ye Google ka policy hai, koi bypass nahi)
2. App create karo → "Noor VPN"
3. **App content section** me:
   - Privacy Policy URL daalo (PRIVACY_POLICY.md ko GitHub Pages / Google Sites pe host karke link banao)
   - **VPN service declaration form bharo** — Google specifically VPN apps se ye poochta hai (kya data collect karte ho, kaise route karte ho)
   - Data safety form bharo (AdMob advertising ID declare karo)
4. Store listing me STORE_LISTING.md ka content paste karo
5. Screenshots + feature graphic upload karo
6. `.aab` upload karo (Production ya pehle Internal Testing track)
7. Review submit — usually 1-7 din lagte hain

---

## Monetization tip (Gulf market)
- Rewarded ads (server unlock) generally banner se zyada CPM dete hain, especially Gulf region me
- App me already "watch ad to unlock premium server" flow bana hua hai — isko highlight karo home screen pe

## Realistic timeline
- Server + backend setup: 1-2 din (agar naye ho to)
- Build + test: 1 din
- Play Store review: 1 week tak

Kisi bhi step pe atko to bata dena — us specific step ka detailed walkthrough de sakta hoon.
