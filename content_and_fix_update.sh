#!/bin/bash
set -e
cat > src/i18n.js <<'FILEEOF'
import React, { createContext, useContext, useState } from "react";

export const LANGUAGES = { en: "EN", hi: "हि", or: "ଓଡ଼" };

// Customer-facing strings only — the admin panel stays English since
// it's an internal tool for the business owner.
// NOTE: Hindi and especially Odia are best-effort machine translations.
// Please have a native speaker review the "or" column before fully
// trusting it on the live site.
const STRINGS = {
  tagline: {
    en: "TOURS, TRAVEL & VEHICLE RENTAL",
    hi: "टूर, यात्रा और वाहन किराया",
    or: "ଟୁର୍, ଯାତ୍ରା ଏବଂ ଗାଡ଼ି ଭଡ଼ା",
  },
  heroTitle1: { en: "DISCOVER", hi: "ओडिशा को", or: "ଓଡ଼ିଶାକୁ" },
  heroTitle2: { en: "ODISHA", hi: "खोजें", or: "ଆବିଷ୍କାର କରନ୍ତୁ" },
  heroSubtitle: {
    en: "Sightseeing tours, holiday planning, and vehicle rentals — your complete travel partner in Bhubaneswar.",
    hi: "दर्शनीय स्थलों की यात्रा, छुट्टियों की योजना, और वाहन किराया — भुवनेश्वर में आपका पूरा यात्रा साथी।",
    or: "ଦର୍ଶନୀୟ ସ୍ଥାନ ଭ୍ରମଣ, ଛୁଟି ଯୋଜନା, ଏବଂ ଗାଡ଼ି ଭଡ଼ା — ଭୁବନେଶ୍ୱରରେ ଆପଣଙ୍କର ସମ୍ପୂର୍ଣ୍ଣ ଯାତ୍ରା ସାଥୀ।",
  },
  searchPlaceholder: {
    en: "Search tours, bikes, cars...",
    hi: "टूर, बाइक, कार खोजें...",
    or: "ଟୁର୍, ବାଇକ୍, କାର୍ ଖୋଜନ୍ତୁ...",
  },

  ourServices: { en: "WHAT WE OFFER", hi: "हम क्या प्रदान करते हैं", or: "ଆମେ କ'ଣ ପ୍ରଦାନ କରୁ" },
  serviceToursTitle: { en: "Sightseeing Tours", hi: "दर्शनीय यात्राएं", or: "ଦର୍ଶନୀୟ ଭ୍ରମଣ" },
  serviceToursDesc: { en: "Guided day trips across Bhubaneswar & Odisha", hi: "भुवनेश्वर और ओडिशा में गाइडेड डे ट्रिप", or: "ଭୁବନେଶ୍ୱର ଏବଂ ଓଡ଼ିଶାରେ ଗାଇଡେଡ୍ ଡେ ଟ୍ରିପ୍" },
  serviceCustomTitle: { en: "Custom Trip Planning", hi: "कस्टम यात्रा योजना", or: "କଷ୍ଟମ୍ ଯାତ୍ରା ଯୋଜନା" },
  serviceCustomDesc: { en: "Tell us your plan, we'll tailor the rest", hi: "अपनी योजना बताएं, बाकी हम संभालेंगे", or: "ଆପଣଙ୍କ ଯୋଜନା କୁହନ୍ତୁ, ବାକି ଆମେ ସମ୍ଭାଳିବୁ" },
  serviceGroupTitle: { en: "Group & Corporate Travel", hi: "समूह और कॉर्पोरेट यात्रा", or: "ଗ୍ରୁପ୍ ଏବଂ କର୍ପୋରେଟ୍ ଯାତ୍ରା" },
  serviceGroupDesc: { en: "Special rates for groups and businesses", hi: "समूहों और व्यवसायों के लिए विशेष दरें", or: "ଗ୍ରୁପ୍ ଏବଂ ବ୍ୟବସାୟ ପାଇଁ ବିଶେଷ ଦର" },
  enquireWhatsapp: { en: "Enquire on WhatsApp", hi: "WhatsApp पर पूछें", or: "WhatsApp ରେ ପଚାରନ୍ତୁ" },
  exploreTours: { en: "Explore tours", hi: "टूर देखें", or: "ଟୁର୍ ଦେଖନ୍ତୁ" },
  viewVehicles: { en: "View vehicles", hi: "वाहन देखें", or: "ଗାଡ଼ି ଦେଖନ୍ତୁ" },

  toursSectionSubtitle: {
    en: "Our main offering — guided day trips across Odisha",
    hi: "हमारी मुख्य सेवा — ओडिशा भर में गाइडेड डे ट्रिप",
    or: "ଆମର ମୁଖ୍ୟ ସେବା — ଓଡ଼ିଶା ସାରା ଗାଇଡେଡ୍ ଡେ ଟ୍ରିପ୍",
  },
  ourFleetHeading: { en: "OUR FLEET", hi: "हमारा फ्लीट", or: "ଆମର ଫ୍ଲିଟ୍" },
  ourFleetSubtitle: {
    en: "A look at the bikes, cars, and buses we work with. Want to actually take one out? Book a driver or rider through Travels above, or reach us on WhatsApp.",
    hi: "हमारे साथ काम करने वाली बाइक, कार और बसों की एक झलक। किसी एक को असल में लेना है? ऊपर ट्रैवल्स के ज़रिए ड्राइवर या राइडर बुक करें, या WhatsApp पर संपर्क करें।",
    or: "ଆମ ସହିତ କାମ କରୁଥିବା ବାଇକ୍, କାର୍ ଏବଂ ବସ୍ର ଏକ ଝଲକ। ପ୍ରକୃତରେ ଗୋଟିଏ ନେବାକୁ ଚାହୁଁଛନ୍ତି? ଉପରେ ଥିବା ଟ୍ରାଭେଲ୍ସ ମାଧ୍ୟମରେ ଡ୍ରାଇଭର କିମ୍ବା ରାଇଡର ବୁକ୍ କରନ୍ତୁ, କିମ୍ବା WhatsApp ରେ ଯୋଗାଯୋଗ କରନ୍ତୁ।",
  },

  bikes: { en: "Bikes", hi: "बाइक", or: "ବାଇକ୍" },
  cars: { en: "Cars", hi: "कार", or: "କାର୍" },
  buses: { en: "Buses", hi: "बस", or: "ବସ୍" },
  tours: { en: "Tours", hi: "टूर", or: "ଟୁର୍" },
  packages: { en: "Packages", hi: "पैकेज", or: "ପ୍ୟାକେଜ୍" },
  travels: { en: "Travels", hi: "यात्राएं", or: "ଯାତ୍ରା" },
  packagesSectionSubtitle: {
    en: "All-inclusive trips — stay, food, and sightseeing bundled together.",
    hi: "सर्व-समावेशी यात्राएं — ठहरना, खाना और घूमना सब एक साथ।",
    or: "ସର୍ବସମ୍ମିଳିତ ଯାତ୍ରା — ରହିବା, ଖାଦ୍ୟ ଏବଂ ଭ୍ରମଣ ଏକାଠି।",
  },
  travelsSectionSubtitle: {
    en: "Not sure where you want to go? Book a car or bike with a driver/rider and roam as you please.",
    hi: "पक्का नहीं कि कहाँ जाना है? ड्राइवर/राइडर के साथ कार या बाइक बुक करें और अपनी मर्ज़ी से घूमें।",
    or: "କେଉଁଠି ଯିବେ ନିଶ୍ଚିତ ନାହିଁ? ଡ୍ରାଇଭର/ରାଇଡର ସହିତ କାର୍ କିମ୍ବା ବାଇକ୍ ବୁକ୍ କରନ୍ତୁ ଏବଂ ନିଜ ମର୍ଜିରେ ବୁଲନ୍ତୁ।",
  },
  sortLabel: { en: "Sort", hi: "क्रम", or: "କ୍ରମ" },
  sortDefault: { en: "Default", hi: "डिफ़ॉल्ट", or: "ଡିଫଲ୍ଟ" },
  sortPriceLow: { en: "Price: Low to High", hi: "कीमत: कम से ज़्यादा", or: "ମୂଲ୍ୟ: କମରୁ ଅଧିକ" },
  sortPriceHigh: { en: "Price: High to Low", hi: "कीमत: ज़्यादा से कम", or: "ମୂଲ୍ୟ: ଅଧିକରୁ କମ" },
  book: { en: "Book", hi: "बुक करें", or: "ବୁକ୍ କରନ୍ତୁ" },
  selected: { en: "Selected", hi: "चयनित", or: "ମନୋନୀତ" },
  booking: { en: "BOOKING", hi: "बुकिंग", or: "ବୁକିଂ" },
  selectDate: { en: "SELECT DATE", hi: "तारीख़ चुनें", or: "ତାରିଖ ବାଛନ୍ତୁ" },
  selectTime: { en: "SELECT TIME", hi: "समय चुनें", or: "ସମୟ ବାଛନ୍ତୁ" },
  selectPickupTime: { en: "SELECT PICKUP TIME", hi: "पिकअप समय चुनें", or: "ପିକଅପ୍ ସମୟ ବାଛନ୍ତୁ" },
  multiDay: { en: "Multiple days", hi: "कई दिन", or: "ଏକାଧିକ ଦିନ" },
  startDate: { en: "Start date", hi: "शुरुआत की तारीख़", or: "ଆରମ୍ଭ ତାରିଖ" },
  endDate: { en: "End date", hi: "अंतिम तारीख़", or: "ଶେଷ ତାରିଖ" },
  totalFor: { en: "Total for", hi: "कुल", or: "ମୋଟ" },
  days: { en: "days", hi: "दिन", or: "ଦିନ" },
  fullName: { en: "Full name", hi: "पूरा नाम", or: "ପୂରା ନାମ" },
  phoneNumber: { en: "Phone number", hi: "फ़ोन नंबर", or: "ଫୋନ୍ ନମ୍ବର" },
  emailAddress: { en: "Email address", hi: "ईमेल पता", or: "ଇମେଲ୍ ଠିକଣା" },
  couponCode: { en: "Coupon code (optional)", hi: "कूपन कोड (वैकल्पिक)", or: "କୁପନ୍ କୋଡ୍ (ଇଚ୍ଛାଧୀନ)" },
  apply: { en: "Apply", hi: "लागू करें", or: "ଲାଗୁ କରନ୍ତୁ" },
  couponApplied: { en: "applied", hi: "लागू", or: "ଲାଗୁ ହୋଇଛି" },
  invalidCoupon: { en: "Invalid or expired code", hi: "अमान्य या समाप्त कोड", or: "ଅବୈଧ କିମ୍ବା ମିଆଦ ସରିଥିବା କୋଡ୍" },
  confirmBooking: { en: "Confirm Booking", hi: "बुकिंग पक्की करें", or: "ବୁକିଂ ନିଶ୍ଚିତ କରନ୍ତୁ" },
  reviews: { en: "Reviews", hi: "समीक्षाएं", or: "ସମୀକ୍ଷା" },
  leaveReview: { en: "Leave a review", hi: "समीक्षा लिखें", or: "ସମୀକ୍ଷା ଲେଖନ୍ତୁ" },
  yourName: { en: "Your name", hi: "आपका नाम", or: "ଆପଣଙ୍କ ନାମ" },
  yourReview: { en: "Your review (optional)", hi: "आपकी समीक्षा (वैकल्पिक)", or: "ଆପଣଙ୍କ ସମୀକ୍ଷା (ଇଚ୍ଛାଧୀନ)" },
  submitReview: { en: "Submit review", hi: "समीक्षा भेजें", or: "ସମୀକ୍ଷା ପଠାନ୍ତୁ" },
  reviewSubmitted: { en: "Thanks! Your review will appear after approval.", hi: "धन्यवाद! स्वीकृति के बाद आपकी समीक्षा दिखेगी।", or: "ଧନ୍ୟବାଦ! ଅନୁମୋଦନ ପରେ ଆପଣଙ୍କ ସମୀକ୍ଷା ଦେଖାଯିବ।" },
  questionsReachUs: { en: "QUESTIONS? REACH US DIRECTLY", hi: "सवाल हैं? सीधे संपर्क करें", or: "ପ୍ରଶ୍ନ ଅଛି? ସିଧାସଳଖ ଯୋଗାଯୋଗ କରନ୍ତୁ" },
  checkBooking: { en: "Check a booking", hi: "बुकिंग जांचें", or: "ବୁକିଂ ଯାଞ୍ଚ କରନ୍ତୁ" },
  admin: { en: "admin", hi: "admin", or: "admin" },

  addToTrip: { en: "Add to Trip", hi: "ट्रिप में जोड़ें", or: "ଟ୍ରିପ୍ ରେ ଯୋଡ଼ନ୍ତୁ" },
  addedToTrip: { en: "Added", hi: "जोड़ा गया", or: "ଯୋଡ଼ାଗଲା" },
  myTrip: { en: "My Trip", hi: "मेरी ट्रिप", or: "ମୋ ଟ୍ରିପ୍" },
  tripEmpty: { en: "Your trip list is empty. Tap \"Add to Trip\" on anything you like.", hi: "आपकी ट्रिप सूची खाली है। जो पसंद है उस पर \"ट्रिप में जोड़ें\" दबाएं।", or: "ଆପଣଙ୍କ ଟ୍ରିପ୍ ତାଲିକା ଖାଲି। ପସନ୍ଦର ଜିନିଷରେ \"ଟ୍ରିପ୍ ରେ ଯୋଡ଼ନ୍ତୁ\" ଦବାନ୍ତୁ।" },
  removeFromTrip: { en: "Remove", hi: "हटाएं", or: "ହଟାନ୍ତୁ" },
  sendTripRequest: { en: "Send Trip Request", hi: "ट्रिप अनुरोध भेजें", or: "ଟ୍ରିପ୍ ଅନୁରୋଧ ପଠାନ୍ତୁ" },
  tripRequestSent: { en: "Sent! We'll reach out on WhatsApp to plan the details.", hi: "भेज दिया! हम विवरण तय करने के लिए WhatsApp पर संपर्क करेंगे।", or: "ପଠାଗଲା! ବିବରଣୀ ଯୋଜନା କରିବାକୁ ଆମେ WhatsApp ରେ ଯୋଗାଯୋଗ କରିବୁ।" },
  popular: { en: "Popular", hi: "लोकप्रिय", or: "ଲୋକପ୍ରିୟ" },
  cancellationPolicy: {
    en: "Free cancellation up to 24 hours before your slot.",
    hi: "अपने स्लॉट से 24 घंटे पहले तक मुफ़्त रद्दीकरण।",
    or: "ଆପଣଙ୍କ ସ୍ଲଟ୍ ପୂର୍ବରୁ 24 ଘଣ୍ଟା ପର୍ଯ୍ୟନ୍ତ ମାଗଣା ବାତିଲ୍।",
  },
  viewAll: { en: "View all", hi: "सभी देखें", or: "ସବୁ ଦେଖନ୍ତୁ" },
  showLess: { en: "Show less", hi: "कम दिखाएं", or: "କମ୍ ଦେଖାନ୍ତୁ" },
  aboutThisTour: { en: "About this tour", hi: "इस टूर के बारे में", or: "ଏହି ଟୁର୍ ବିଷୟରେ" },
  whatToKnow: { en: "What to know before you go", hi: "जाने से पहले जान लें", or: "ଯିବା ପୂର୍ବରୁ ଜାଣନ୍ତୁ" },
  bookNow: { en: "Book Now", hi: "अभी बुक करें", or: "ବର୍ତ୍ତମାନ ବୁକ୍ କରନ୍ତୁ" },

  planYourJourney: { en: "PLAN YOUR JOURNEY", hi: "अपनी यात्रा की योजना बनाएं", or: "ଆପଣଙ୍କ ଯାତ୍ରା ଯୋଜନା କରନ୍ତୁ" },
  whyChooseTitle: { en: "Why Travel With RideLine?", hi: "RideLine के साथ यात्रा क्यों करें?", or: "RideLine ସହିତ କାହିଁକି ଯାତ୍ରା କରିବେ?" },
  whyChoose1: { en: "Customised Tour Packages", hi: "कस्टमाइज्ड टूर पैकेज", or: "କଷ୍ଟମାଇଜ୍ଡ ଟୁର୍ ପ୍ୟାକେଜ୍" },
  whyChoose2: { en: "Hassle-Free Travel Planning", hi: "परेशानी मुक्त यात्रा योजना", or: "ଝାମେଲାମୁକ୍ତ ଯାତ୍ରା ଯୋଜନା" },
  whyChoose3: { en: "Expert Local Guidance", hi: "स्थानीय विशेषज्ञ मार्गदर्शन", or: "ସ୍ଥାନୀୟ ବିଶେଷଜ୍ଞ ମାର୍ଗଦର୍ଶନ" },
  whyChoose4: { en: "Quick WhatsApp Support", hi: "त्वरित WhatsApp सहायता", or: "ତ୍ୱରିତ WhatsApp ସହାୟତା" },

  aboutTag: { en: "OUR STORY", hi: "हमारी कहानी", or: "ଆମର କାହାଣୀ" },
  aboutHeading: { en: "Welcome to RideLine", hi: "RideLine में आपका स्वागत है", or: "RideLine କୁ ସ୍ୱାଗତ" },
  aboutBody: {
    en: "We started RideLine to make exploring Odisha simple — real local knowledge, honest pricing, and a team that actually picks up the phone. From ancient temples to quiet backwaters, we help you see the state the way we do: unhurried, and worth every mile.",
    hi: "हमने ओडिशा को आसानी से घूमने के लिए RideLine शुरू किया — असली स्थानीय जानकारी, ईमानदार कीमतें, और एक टीम जो वाकई फोन उठाती है। प्राचीन मंदिरों से लेकर शांत जलमार्गों तक, हम आपको राज्य को उसी तरह दिखाते हैं जैसे हम देखते हैं — बिना जल्दबाजी, और हर मील के लायक।",
    or: "ଓଡ଼ିଶାକୁ ସହଜରେ ଭ୍ରମଣ କରାଇବା ପାଇଁ ଆମେ RideLine ଆରମ୍ଭ କଲୁ — ପ୍ରକୃତ ସ୍ଥାନୀୟ ଜ୍ଞାନ, ସାଧୁ ମୂଲ୍ୟ, ଏବଂ ଏକ ଦଳ ଯିଏ ପ୍ରକୃତରେ ଫୋନ୍ ଉଠାନ୍ତି। ପ୍ରାଚୀନ ମନ୍ଦିରରୁ ଶାନ୍ତ ଜଳପଥ ପର୍ଯ୍ୟନ୍ତ, ଆମେ ଆପଣଙ୍କୁ ରାଜ୍ୟକୁ ଆମ ପରି ଦେଖାଇବାରେ ସାହାଯ୍ୟ କରୁ — ଅବିରତ, ଏବଂ ପ୍ରତ୍ୟେକ ମାଇଲ ଉପଯୁକ୍ତ।",
  },

  popularDestHeading: { en: "Popular Destinations", hi: "लोकप्रिय स्थान", or: "ଲୋକପ୍ରିୟ ଗନ୍ତବ୍ୟସ୍ଥଳ" },
  popularDestSubtitle: { en: "A few favourites from our tours", hi: "हमारे टूर से कुछ पसंदीदा", or: "ଆମର ଟୁର୍ ର କିଛି ପ୍ରିୟ ସ୍ଥାନ" },

  testimonialsHeading: { en: "What Travellers Say", hi: "यात्री क्या कहते हैं", or: "ଯାତ୍ରୀମାନେ କ'ଣ କୁହନ୍ତି" },

  footerQuickLinks: { en: "QUICK LINKS", hi: "त्वरित लिंक", or: "ଦ୍ରୁତ ଲିଙ୍କ୍" },
  footerFindUs: { en: "FIND US", hi: "हमें खोजें", or: "ଆମକୁ ଖୋଜନ୍ତୁ" },
  allRightsReserved: { en: "All rights reserved.", hi: "सर्वाधिकार सुरक्षित।", or: "ସର୍ବସ୍ୱତ୍ୱ ସଂରକ୍ଷିତ।" },

  whySection1Heading: { en: "Why Choose RideLine", hi: "RideLine क्यों चुनें", or: "RideLine କାହିଁକି ବାଛିବେ" },
  why1Title: { en: "Local Expertise You Can Trust", hi: "स्थानीय विशेषज्ञता जिस पर आप भरोसा कर सकते हैं", or: "ସ୍ଥାନୀୟ ବିଶେଷଜ୍ଞତା ଯାହା ଉପରେ ଆପଣ ଭରସା କରିପାରିବେ" },
  why1Body: {
    en: "We're not a call center reading off a script — we're based right here in Bhubaneswar, and every route, temple timing, and seasonal note on this site comes from people who've actually made the trip. That local grounding means fewer surprises and better recommendations, whether you're asking about a dress code or the best month to visit.",
    hi: "हम कोई स्क्रिप्ट पढ़ने वाला कॉल सेंटर नहीं हैं — हम खुद भुवनेश्वर में स्थित हैं, और इस साइट पर हर रूट, मंदिर का समय और मौसमी जानकारी उन लोगों से आती है जिन्होंने वाकई वह यात्रा की है। इस स्थानीय आधार का मतलब है कम आश्चर्य और बेहतर सलाह — चाहे आप पोशाक नियम के बारे में पूछें या घूमने का सबसे अच्छा महीना।",
    or: "ଆମେ କୌଣସି ସ୍କ୍ରିପ୍ଟ ପଢ଼ୁଥିବା କଲ୍ ସେଣ୍ଟର ନୋହୁଁ — ଆମେ ନିଜେ ଭୁବନେଶ୍ୱରରେ ଅବସ୍ଥିତ, ଏବଂ ଏହି ସାଇଟରେ ପ୍ରତ୍ୟେକ ରୁଟ୍, ମନ୍ଦିର ସମୟ ଏବଂ ଋତୁକାଳୀନ ସୂଚନା ପ୍ରକୃତରେ ସେହି ଯାତ୍ରା କରିଥିବା ଲୋକଙ୍କଠାରୁ ଆସେ। ଏହି ସ୍ଥାନୀୟ ଆଧାର ଅର୍ଥ କମ୍ ଆଶ୍ଚର୍ଯ୍ୟ ଏବଂ ଉତ୍ତମ ପରାମର୍ଶ — ଆପଣ ପୋଷାକ ନିୟମ ବିଷୟରେ ପଚାରନ୍ତୁ କିମ୍ବା ଭ୍ରମଣର ସର୍ବୋତ୍ତମ ମାସ।",
  },
  why2Title: { en: "We Do the Legwork So You Don't Have To", hi: "हम मेहनत करते हैं ताकि आपको न करनी पड़े", or: "ଆମେ ପରିଶ୍ରମ କରୁ ଯାହା ଫଳରେ ଆପଣଙ୍କୁ କରିବାକୁ ପଡ଼ିବ ନାହିଁ" },
  why2Body: {
    en: "Planning a multi-stop trip usually means juggling ten browser tabs — temple hours, driver availability, which beach is quiet on a weekday. We've already done that research and folded it into every tour, package, and travel option here, so booking takes minutes instead of hours.",
    hi: "बहु-पड़ाव यात्रा की योजना बनाने में आमतौर पर दस ब्राउज़र टैब खुले रखने पड़ते हैं — मंदिर के समय, ड्राइवर की उपलब्धता, कौन सा समुद्र तट सप्ताह के दिन शांत रहता है। हमने यह सारी खोज पहले ही कर ली है और इसे हर टूर, पैकेज और ट्रैवल विकल्प में शामिल कर दिया है, ताकि बुकिंग में घंटों नहीं, मिनट लगें।",
    or: "ଏକାଧିକ-ପଡ଼ାବ ଯାତ୍ରା ଯୋଜନା କରିବାରେ ସାଧାରଣତଃ ଦଶଟି ବ୍ରାଉଜର୍ ଟ୍ୟାବ୍ ଖୋଲା ରଖିବାକୁ ପଡ଼େ — ମନ୍ଦିର ସମୟ, ଡ୍ରାଇଭର ଉପଲବ୍ଧତା, କେଉଁ ବେଳାଭୂମି ସପ୍ତାହ ଦିନରେ ଶାନ୍ତ ରହେ। ଆମେ ଏହି ସମସ୍ତ ଅନୁସନ୍ଧାନ ପୂର୍ବରୁ କରି ପ୍ରତ୍ୟେକ ଟୁର୍, ପ୍ୟାକେଜ୍ ଏବଂ ଟ୍ରାଭେଲ୍ ବିକଳ୍ପରେ ଯୋଡ଼ିଦେଇଛୁ, ଯାହା ଫଳରେ ବୁକିଂ ଘଣ୍ଟା ନୁହେଁ, ମିନିଟ୍ ନେଇଥାଏ।",
  },
  why3Title: { en: "Fair, Upfront Pricing", hi: "उचित, स्पष्ट कीमत", or: "ନ୍ୟାୟସଙ୍ଗତ, ସ୍ପଷ୍ଟ ମୂଲ୍ୟ" },
  why3Body: {
    en: "The price shown on each listing is what you pay — no service fees added at checkout, no 'contact for pricing' games. If a coupon applies or a multi-day trip changes the total, you'll see the math before you confirm anything.",
    hi: "हर लिस्टिंग पर दिखाई गई कीमत ही वह है जो आप चुकाते हैं — चेकआउट पर कोई सेवा शुल्क नहीं जोड़ा जाता, कोई 'कीमत के लिए संपर्क करें' वाला खेल नहीं। अगर कोई कूपन लागू होता है या बहु-दिवसीय यात्रा से कुल राशि बदलती है, तो पुष्टि करने से पहले आप गणना देख लेंगे।",
    or: "ପ୍ରତ୍ୟେକ ତାଲିକାରେ ଦେଖାଯାଇଥିବା ମୂଲ୍ୟ ହିଁ ଆପଣ ଦେଉଥିବା ମୂଲ୍ୟ — ଚେକଆଉଟ୍ ରେ କୌଣସି ସେବା ଶୁଳ୍କ ଯୋଡ଼ାଯାଏ ନାହିଁ, କୌଣସି 'ମୂଲ୍ୟ ପାଇଁ ଯୋଗାଯୋଗ କରନ୍ତୁ' ଖେଳ ନାହିଁ। ଯଦି କୌଣସି କୁପନ୍ ପ୍ରଯୁଜ୍ୟ ହୁଏ କିମ୍ବା ବହୁ-ଦିବସୀୟ ଯାତ୍ରାରୁ ମୋଟ ପରିମାଣ ବଦଳେ, ନିଶ୍ଚିତ କରିବା ପୂର୍ବରୁ ଆପଣ ହିସାବ ଦେଖିପାରିବେ।",
  },
  why4Title: { en: "A Trip Shaped Around You, Not a Template", hi: "एक टेम्पलेट नहीं, आपके अनुसार बनी यात्रा", or: "ଏକ ଟେମ୍ପଲେଟ୍ ନୁହେଁ, ଆପଣଙ୍କ ଅନୁଯାୟୀ ତିଆରି ଯାତ୍ରା" },
  why4Body: {
    en: "Not everyone wants the same itinerary. That's why we offer fixed sightseeing tours for structure, all-inclusive packages for convenience, and flexible chauffeur-driven Travels for people who'd rather decide each stop as they go — often within the same booking.",
    hi: "हर किसी को एक जैसा कार्यक्रम नहीं चाहिए होता। इसलिए हम संरचना के लिए तय दर्शनीय स्थलों के टूर, सुविधा के लिए सर्व-समावेशी पैकेज, और उन लोगों के लिए लचीले ड्राइवर-चालित ट्रैवल्स देते हैं जो हर पड़ाव खुद तय करना पसंद करते हैं — अक्सर एक ही बुकिंग में।",
    or: "ସମସ୍ତଙ୍କୁ ସମାନ କାର୍ଯ୍ୟସୂଚୀ ଆବଶ୍ୟକ ହୁଏ ନାହିଁ। ତେଣୁ ଆମେ ସଂରଚନା ପାଇଁ ନିର୍ଦ୍ଧାରିତ ଦର୍ଶନୀୟ ସ୍ଥାନ ଟୁର୍, ସୁବିଧା ପାଇଁ ସର୍ବସମ୍ମିଳିତ ପ୍ୟାକେଜ୍, ଏବଂ ପ୍ରତ୍ୟେକ ବିରତି ନିଜେ ସ୍ଥିର କରିବାକୁ ଚାହୁଁଥିବା ଲୋକଙ୍କ ପାଇଁ ନମନୀୟ ଡ୍ରାଇଭର-ଚାଳିତ ଟ୍ରାଭେଲ୍ସ ଦେଉ — ପ୍ରାୟତଃ ଏକା ବୁକିଂରେ।",
  },
  why5Title: { en: "Support That Doesn't Disappear After Checkout", hi: "चेकआउट के बाद गायब न होने वाला सहयोग", or: "ଚେକଆଉଟ୍ ପରେ ଅଦୃଶ୍ୟ ନହେଉଥିବା ସହାୟତା" },
  why5Body: {
    en: "Plans change — a flight gets delayed, a temple closes for a festival, someone in your group falls sick. Every confirmation routes straight to WhatsApp, so if something comes up, you're messaging an actual person who already has your booking details, not starting from zero.",
    hi: "योजनाएं बदलती हैं — कोई फ्लाइट लेट हो जाती है, कोई मंदिर त्योहार के लिए बंद हो जाता है, आपके समूह में कोई बीमार पड़ जाता है। हर पुष्टि सीधे WhatsApp पर जाती है, इसलिए अगर कुछ आता है, तो आप एक असली इंसान से बात कर रहे होते हैं जिसके पास पहले से आपकी बुकिंग की जानकारी है, शून्य से शुरुआत नहीं।",
    or: "ଯୋଜନା ବଦଳେ — ଏକ ଫ୍ଲାଇଟ୍ ବିଳମ୍ବିତ ହୁଏ, ଏକ ମନ୍ଦିର ପର୍ବ ପାଇଁ ବନ୍ଦ ହୁଏ, ଆପଣଙ୍କ ଗ୍ରୁପ୍ ରେ କେହି ଅସୁସ୍ଥ ହୁଅନ୍ତି। ପ୍ରତ୍ୟେକ ନିଶ୍ଚିତକରଣ ସିଧାସଳଖ WhatsApp କୁ ଯାଏ, ତେଣୁ କିଛି ଘଟିଲେ, ଆପଣ ଜଣେ ପ୍ରକୃତ ବ୍ୟକ୍ତିଙ୍କ ସହିତ କଥା ହେଉଛନ୍ତି ଯାହାଙ୍କ ପାଖରେ ପୂର୍ବରୁ ଆପଣଙ୍କ ବୁକିଂ ବିବରଣୀ ଅଛି, ଶୂନ୍ୟରୁ ଆରମ୍ଭ ନୁହେଁ।",
  },

  whySection2Heading: { en: "How RideLine Helps You Travel Better", hi: "RideLine आपको बेहतर यात्रा करने में कैसे मदद करता है", or: "RideLine ଆପଣଙ୍କୁ ଉତ୍ତମ ଭାବେ ଯାତ୍ରା କରିବାରେ କିପରି ସାହାଯ୍ୟ କରେ" },
  help1Title: { en: "Real Local Experiences, Not Just the Postcard Spots", hi: "असली स्थानीय अनुभव, सिर्फ पोस्टकार्ड वाली जगहें नहीं", or: "ପ୍ରକୃତ ସ୍ଥାନୀୟ ଅନୁଭୂତି, କେବଳ ପୋଷ୍ଟକାର୍ଡ ସ୍ଥାନ ନୁହେଁ" },
  help1Body: {
    en: "Alongside Konark and Lingaraj, we deliberately built in places most visitors miss — the 64 Yogini temple at Hirapur, Chandaka's wild elephant reserve, Pipili's applique workshops. If you want the well-known highlights, they're here; if you want to go a layer deeper, that's here too.",
    hi: "कोणार्क और लिंगराज के साथ-साथ, हमने जानबूझकर ऐसी जगहें शामिल की हैं जो ज्यादातर पर्यटक चूक जाते हैं — हीरापुर का 64 योगिनी मंदिर, चंडका का जंगली हाथी रिजर्व, पिपिली की एप्लीक कार्यशालाएं। अगर आप जानी-मानी जगहें चाहते हैं, वे यहां हैं; अगर आप एक परत गहराई में जाना चाहते हैं, वह भी यहां है।",
    or: "କୋଣାର୍କ ଏବଂ ଲିଙ୍ଗରାଜ ସହିତ, ଆମେ ଇଚ୍ଛାକୃତ ଭାବେ ଅଧିକାଂଶ ପର୍ଯ୍ୟଟକ ଛାଡ଼ିଦେଉଥିବା ସ୍ଥାନ ଅନ୍ତର୍ଭୁକ୍ତ କରିଛୁ — ହିରାପୁରର 64 ଯୋଗିନୀ ମନ୍ଦିର, ଚନ୍ଦକାର ବଣୁଆ ହାତୀ ସଂରକ୍ଷଣାଳୟ, ପିପିଲିର ଆପ୍ଲିକ୍ କର୍ମଶାଳା। ଯଦି ଆପଣ ପରିଚିତ ଆକର୍ଷଣ ଚାହାଁନ୍ତି, ସେଗୁଡ଼ିକ ଏଠାରେ ଅଛି; ଯଦି ଆପଣ ଏକ ସ୍ତର ଗଭୀରକୁ ଯିବାକୁ ଚାହାଁନ୍ତି, ତାହା ମଧ୍ୟ ଏଠାରେ ଅଛି।",
  },
  help2Title: { en: "Group and Corporate Trips, Handled Properly", hi: "समूह और कॉर्पोरेट यात्राएं, सही ढंग से संभाली गईं", or: "ଗ୍ରୁପ୍ ଏବଂ କର୍ପୋରେଟ୍ ଯାତ୍ରା, ସଠିକ୍ ଭାବେ ପରିଚାଳିତ" },
  help2Body: {
    en: "Coordinating a family reunion, a friend group, or a company offsite comes with its own logistics — bigger vehicles, group rates, one point of contact instead of ten separate bookings. Our bus and multi-day Travels options exist specifically for this, and our Trip Builder lets you bundle several bookings into a single enquiry.",
    hi: "परिवार पुनर्मिलन, दोस्तों के समूह, या कंपनी ऑफसाइट का समन्वय करने में अपनी खुद की व्यवस्था होती है — बड़े वाहन, समूह दरें, दस अलग-अलग बुकिंग के बजाय एक संपर्क बिंदु। हमारे बस और बहु-दिवसीय ट्रैवल्स विकल्प खासतौर पर इसी के लिए हैं, और हमारा ट्रिप बिल्डर आपको कई बुकिंग को एक ही पूछताछ में जोड़ने देता है।",
    or: "ପାରିବାରିକ ପୁନର୍ମିଳନ, ବନ୍ଧୁ ଗ୍ରୁପ୍, କିମ୍ବା କମ୍ପାନୀ ଅଫସାଇଟ୍ ସମନ୍ୱୟ କରିବାରେ ନିଜସ୍ୱ ବ୍ୟବସ୍ଥା ରହିଛି — ବଡ଼ ଗାଡ଼ି, ଗ୍ରୁପ୍ ଦର, ଦଶଟି ପୃଥକ ବୁକିଂ ପରିବର୍ତ୍ତେ ଏକ ଯୋଗାଯୋଗ ବିନ୍ଦୁ। ଆମର ବସ୍ ଏବଂ ବହୁ-ଦିବସୀୟ ଟ୍ରାଭେଲ୍ସ ବିକଳ୍ପ ବିଶେଷ ଭାବେ ଏଥିପାଇଁ ଅଛି, ଏବଂ ଆମର ଟ୍ରିପ୍ ବିଲ୍ଡର୍ ଆପଣଙ୍କୁ ଏକାଧିକ ବୁକିଂକୁ ଏକ ଅନୁରୋଧରେ ମିଶାଇବାକୁ ଦିଏ।",
  },
  help3Title: { en: "Multi-Day and Flexible Booking, Built In", hi: "बहु-दिवसीय और लचीली बुकिंग, पहले से शामिल", or: "ବହୁ-ଦିବସୀୟ ଏବଂ ନମନୀୟ ବୁକିଂ, ପୂର୍ବରୁ ଅନ୍ତର୍ଭୁକ୍ତ" },
  help3Body: {
    en: "A single afternoon temple visit and a five-day Odisha circuit shouldn't require two different websites. Multi-day booking is built into vehicle rentals and Travels directly, so a longer trip is just a date range, not a separate conversation.",
    hi: "एक दोपहर के मंदिर दर्शन और पांच दिन के ओडिशा दौरे को दो अलग-अलग वेबसाइट की जरूरत नहीं होनी चाहिए। बहु-दिवसीय बुकिंग सीधे वाहन किराए और ट्रैवल्स में शामिल है, इसलिए लंबी यात्रा बस एक तारीख सीमा है, अलग बातचीत नहीं।",
    or: "ଏକ ଅପରାହ୍ନ ମନ୍ଦିର ଦର୍ଶନ ଏବଂ ପାଞ୍ଚ ଦିନର ଓଡ଼ିଶା ଭ୍ରମଣକୁ ଦୁଇଟି ଭିନ୍ନ ୱେବସାଇଟ୍ ଆବଶ୍ୟକ ହେବା ଉଚିତ ନୁହେଁ। ବହୁ-ଦିବସୀୟ ବୁକିଂ ସିଧାସଳଖ ଗାଡ଼ି ଭଡ଼ା ଏବଂ ଟ୍ରାଭେଲ୍ସରେ ଅନ୍ତର୍ଭୁକ୍ତ, ତେଣୁ ଏକ ଲମ୍ବା ଯାତ୍ରା କେବଳ ଏକ ତାରିଖ ପରିସର, ପୃଥକ ବାର୍ତ୍ତାଳାପ ନୁହେଁ।",
  },
  help4Title: { en: "Always One Message Away", hi: "हमेशा एक संदेश की दूरी पर", or: "ସର୍ବଦା ଏକ ବାର୍ତ୍ତା ଦୂରରେ" },
  help4Body: {
    en: "Every booking — tour, package, or travel — ends the same way: a confirmation ready to send straight to our WhatsApp. No account to create, no app to download, just a real conversation whenever you need to change or check something.",
    hi: "हर बुकिंग — टूर, पैकेज, या ट्रैवल — एक ही तरह खत्म होती है: हमारे WhatsApp पर सीधे भेजने के लिए तैयार एक पुष्टि। कोई खाता बनाने की जरूरत नहीं, कोई ऐप डाउनलोड करने की जरूरत नहीं, बस जब भी आपको कुछ बदलना या जांचना हो, एक असली बातचीत।",
    or: "ପ୍ରତ୍ୟେକ ବୁକିଂ — ଟୁର୍, ପ୍ୟାକେଜ୍, କିମ୍ବା ଟ୍ରାଭେଲ୍ — ସମାନ ଭାବେ ସମାପ୍ତ ହୁଏ: ଆମର WhatsApp କୁ ସିଧାସଳଖ ପଠାଇବା ପାଇଁ ପ୍ରସ୍ତୁତ ଏକ ନିଶ୍ଚିତକରଣ। କୌଣସି ଆକାଉଣ୍ଟ ତିଆରି କରିବାକୁ ପଡ଼ିବ ନାହିଁ, କୌଣସି ଆପ୍ ଡାଉନଲୋଡ୍ କରିବାକୁ ପଡ଼ିବ ନାହିଁ, କେବଳ ଯେତେବେଳେ ମଧ୍ୟ ଆପଣଙ୍କୁ କିଛି ବଦଳାଇବାକୁ କିମ୍ବା ଯାଞ୍ଚ କରିବାକୁ ପଡ଼ିବ, ଏକ ପ୍ରକୃତ ବାର୍ତ୍ତାଳାପ।",
  },
};

export function t(key, lang) {
  return STRINGS[key]?.[lang] || STRINGS[key]?.en || key;
}

const LanguageContext = createContext(null);

export function LanguageProvider({ children }) {
  const [lang, setLang] = useState(() => {
    try {
      return localStorage.getItem("rideline-lang") || "en";
    } catch {
      return "en";
    }
  });

  function changeLang(newLang) {
    setLang(newLang);
    try {
      localStorage.setItem("rideline-lang", newLang);
    } catch {
      // ignore storage errors
    }
  }

  return React.createElement(LanguageContext.Provider, { value: { lang, setLang: changeLang } }, children);
}

export function useLanguage() {
  const ctx = useContext(LanguageContext);
  if (!ctx) throw new Error("useLanguage must be used within a LanguageProvider");
  return ctx;
}

FILEEOF

cat > src/pages/Booking.jsx <<'FILEEOF'
import React, { useState, useEffect, useMemo, useRef } from "react";
import {
  Bike,
  Car,
  Bus,
  Landmark,
  Instagram,
  Facebook,
  MessageCircle,
  Check,
  Clock,
  MapPin,
  ChevronRight,
  Loader2,
  User,
  Phone,
  Mail,
  Search,
  X,
  Star,
  Tag,
  CalendarRange,
  ClipboardList,
  Compass,
  Users,
  Briefcase,
  Plus,
  Trash2,
  ShieldCheck,
  Package,
  Route,
} from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { BUSINESS, SLOTS, CANCELLATION_POLICY_HOURS } from "../config.js";
import { useTheme } from "../ThemeContext.jsx";
import ThemeToggle from "../components/ThemeToggle.jsx";
import LanguageToggle from "../components/LanguageToggle.jsx";
import { useLanguage, t } from "../i18n.js";
import { ADSENSE_SLOTS } from "../config.js";
import AdUnit from "../components/AdUnit.jsx";

// Tours lead — vehicle rental is a supporting service, not the headline.
const TOUR_CATEGORY = { key: "tour", labelKey: "tours", icon: Landmark, tint: "rgba(245,110,110,0.14)" };
const PACKAGE_CATEGORY = { key: "package", labelKey: "packages", icon: Package, tint: "rgba(122,200,245,0.14)" };
const TRAVEL_CATEGORY = { key: "travel", labelKey: "travels", icon: Route, tint: "rgba(180,140,245,0.14)" };
const VEHICLE_CATEGORIES = [
  { key: "bike", labelKey: "bikes", icon: Bike, tint: "rgba(245,183,0,0.16)" },
  { key: "car", labelKey: "cars", icon: Car, tint: "rgba(37,211,102,0.14)" },
  { key: "bus", labelKey: "buses", icon: Bus, tint: "rgba(122,110,245,0.16)" },
];


function nextDays(n) {
  const out = [];
  const today = new Date();
  for (let i = 0; i < n; i++) {
    const d = new Date(today);
    d.setDate(today.getDate() + i);
    out.push(d);
  }
  return out;
}
function dateKey(d) {
  return d.toISOString().slice(0, 10);
}
function dayLabel(d) {
  return d.toLocaleDateString("en-US", { weekday: "short" }).toUpperCase();
}
function isPastSlot(dateStr, slotTime) {
  const now = new Date();
  if (dateStr !== dateKey(now)) return false; // only today's date can have "past" slots
  const [h, m] = slotTime.split(":").map(Number);
  const slotDate = new Date();
  slotDate.setHours(h, m, 0, 0);
  return slotDate <= now;
}
function daysBetweenInclusive(startStr, endStr) {
  const out = [];
  const start = new Date(startStr);
  const end = new Date(endStr);
  if (end < start) return out;
  const cur = new Date(start);
  while (cur <= end) {
    out.push(dateKey(cur));
    cur.setDate(cur.getDate() + 1);
  }
  return out;
}

export default function Booking() {
  const { colors: COLORS, resolved: themeMode } = useTheme();
  const { lang } = useLanguage();
  const tr = (key) => t(key, lang);

  const [allListings, setAllListings] = useState({ bike: [], car: [], bus: [], tour: [], package: [], travel: [] });
  const [reviewStats, setReviewStats] = useState({});
  const [bookingCounts, setBookingCounts] = useState({});
  const [testimonials, setTestimonials] = useState([]);
  const [loadingListings, setLoadingListings] = useState(true);
  const [search, setSearch] = useState("");
  const [sortOrder, setSortOrder] = useState("default");
  const [expandedCats, setExpandedCats] = useState({}); // { bike: true } once "View all" tapped
  const [detailListing, setDetailListing] = useState(null); // { listing, category } for the tour popup

  function toggleExpanded(catKey) {
    setExpandedCats((prev) => ({ ...prev, [catKey]: !prev[catKey] }));
  }

  // Trip Builder — a lightweight "save for a combined enquiry" list,
  // separate from actually booking a specific slot.
  const [myTrip, setMyTrip] = useState(() => {
    try {
      return JSON.parse(localStorage.getItem("rideline-trip") || "[]");
    } catch {
      return [];
    }
  });
  const [tripPanelOpen, setTripPanelOpen] = useState(false);
  const [tripForm, setTripForm] = useState({ name: "", phone: "", email: "" });
  const [tripSubmitting, setTripSubmitting] = useState(false);
  const [tripSent, setTripSent] = useState(false);

  useEffect(() => {
    try {
      localStorage.setItem("rideline-trip", JSON.stringify(myTrip));
    } catch {
      // ignore storage errors
    }
  }, [myTrip]);

  const [selected, setSelected] = useState(null); // { category, listingId }
  const days = useMemo(() => nextDays(14), []);
  const [date, setDate] = useState(dateKey(days[0]));
  const [takenSlots, setTakenSlots] = useState([]);
  const [slot, setSlot] = useState(null);
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [loadingSlots, setLoadingSlots] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [ticket, setTicket] = useState(null);
  const [error, setError] = useState("");

  // Multi-day (bus /day listings only)
  const [multiDay, setMultiDay] = useState(false);
  const [rangeStart, setRangeStart] = useState(dateKey(days[0]));
  const [rangeEnd, setRangeEnd] = useState(dateKey(days[0]));

  // Coupons
  const [couponInput, setCouponInput] = useState("");
  const [couponApplied, setCouponApplied] = useState(null); // { code, discount_percent }
  const [couponChecking, setCouponChecking] = useState(false);
  const [couponError, setCouponError] = useState("");

  // Reviews
  const [panelReviews, setPanelReviews] = useState([]);
  const [reviewForm, setReviewForm] = useState({ name: "", rating: 5, comment: "" });
  const [reviewSubmitting, setReviewSubmitting] = useState(false);
  const [reviewDone, setReviewDone] = useState(false);

  const panelRef = useRef(null);

  // Tour carousel — tracks which large hero card is in view for the dot indicator
  const tourScrollRef = useRef(null);
  const [activeTourIndex, setActiveTourIndex] = useState(0);
  function handleTourScroll() {
    const el = tourScrollRef.current;
    if (!el || !el.firstElementChild) return;
    const cardWidth = el.firstElementChild.offsetWidth + 16; // gap-4 = 16px
    const idx = Math.round(el.scrollLeft / cardWidth);
    setActiveTourIndex(idx);
  }

  // Package carousel — same pattern as tours
  const packageScrollRef = useRef(null);
  const [activePackageIndex, setActivePackageIndex] = useState(0);
  function handlePackageScroll() {
    const el = packageScrollRef.current;
    if (!el || !el.firstElementChild) return;
    const cardWidth = el.firstElementChild.offsetWidth + 16;
    const idx = Math.round(el.scrollLeft / cardWidth);
    setActivePackageIndex(idx);
  }

  useEffect(() => {
    (async () => {
      setLoadingListings(true);
      const [{ data: listingsData }, { data: statsData }, { data: countsData }, { data: testimonialsData }] = await Promise.all([
        supabase.from("listings").select("*").eq("active", true).order("price", { ascending: true }),
        supabase.from("review_stats").select("*"),
        supabase.from("listing_booking_counts").select("*"),
        supabase.from("reviews").select("customer_name, rating, comment, listings(name)").eq("approved", true).gte("rating", 4).order("created_at", { ascending: false }).limit(6),
      ]);
      const grouped = { bike: [], car: [], bus: [], tour: [], package: [], travel: [] };
      (listingsData || []).forEach((l) => {
        if (grouped[l.category]) grouped[l.category].push(l);
      });
      setAllListings(grouped);
      const statsMap = {};
      (statsData || []).forEach((s) => {
        statsMap[s.listing_id] = s;
      });
      setReviewStats(statsMap);
      const countsMap = {};
      (countsData || []).forEach((c) => {
        countsMap[c.listing_id] = c.booking_count;
      });
      setBookingCounts(countsMap);
      setTestimonials((testimonialsData || []).filter((t) => t.comment));
      setLoadingListings(false);
    })();
  }, []);

  const listing = selected ? allListings[selected.category]?.find((l) => l.id === selected.listingId) : null;
  const isMultiDayEligible = listing && listing.category !== "tour" && listing.category !== "package";

  useEffect(() => {
    if (!selected || multiDay) return;
    let cancelled = false;
    (async () => {
      setLoadingSlots(true);
      setSlot(null);
      const { data, error: err } = await supabase
        .from("taken_slots")
        .select("slot_time")
        .eq("listing_id", selected.listingId)
        .eq("booking_date", date);
      if (cancelled) return;
      if (!err) setTakenSlots((data || []).map((r) => r.slot_time));
      setLoadingSlots(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [selected, date, multiDay]);

  useEffect(() => {
    if (selected && panelRef.current) {
      panelRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }, [selected]);

  useEffect(() => {
    if (!selected) {
      setPanelReviews([]);
      return;
    }
    (async () => {
      const { data } = await supabase
        .from("reviews")
        .select("customer_name, rating, comment, created_at")
        .eq("listing_id", selected.listingId)
        .eq("approved", true)
        .order("created_at", { ascending: false })
        .limit(10);
      setPanelReviews(data || []);
    })();
  }, [selected]);

  function chooseListing(category, listingId) {
    setError("");
    setTicket(null);
    setMultiDay(false);
    setCouponApplied(null);
    setCouponInput("");
    setCouponError("");
    setReviewDone(false);
    setSelected({ category, listingId });
  }

  function isInTrip(listingId) {
    return myTrip.some((item) => item.listingId === listingId);
  }

  function toggleTrip(listing, category) {
    setMyTrip((prev) => {
      if (prev.some((item) => item.listingId === listing.id)) {
        return prev.filter((item) => item.listingId !== listing.id);
      }
      return [...prev, { listingId: listing.id, name: listing.name, category, price: listing.price, unit: listing.unit }];
    });
  }

  function removeFromTrip(listingId) {
    setMyTrip((prev) => prev.filter((item) => item.listingId !== listingId));
  }

  async function sendTripRequest(e) {
    e.preventDefault();
    if (!tripForm.name.trim() || !tripForm.phone.trim() || myTrip.length === 0) return;
    setTripSubmitting(true);
    await supabase.from("trip_enquiries").insert({
      customer_name: tripForm.name.trim(),
      customer_phone: tripForm.phone.trim(),
      customer_email: tripForm.email.trim() || null,
      items: myTrip,
    });
    const lines = myTrip.map((item) => `- ${item.name} (₹${item.price}${item.unit})`).join("%0A");
    const msg = `Hi ${BUSINESS.name}! I'd like to plan a trip with:%0A%0A${lines}%0A%0AName: ${tripForm.name.trim()}%0APhone: ${tripForm.phone.trim()}`;
    window.open(`https://wa.me/${BUSINESS.whatsapp}?text=${msg}`, "_blank");
    setTripSubmitting(false);
    setTripSent(true);
    setMyTrip([]);
  }

  async function applyCoupon() {
    if (!couponInput.trim()) return;
    setCouponChecking(true);
    setCouponError("");
    const { data, error: err } = await supabase.rpc("validate_coupon", { p_code: couponInput.trim() });
    setCouponChecking(false);
    if (err || !data || data.length === 0) {
      setCouponError(tr("invalidCoupon"));
      setCouponApplied(null);
      return;
    }
    setCouponApplied(data[0]);
  }

  const rangeDates = multiDay ? daysBetweenInclusive(rangeStart, rangeEnd) : [];
  const rangeDays = rangeDates.length;
  const baseTotal = listing ? (multiDay ? listing.price * rangeDays : listing.price) : 0;
  const discountedTotal = couponApplied ? Math.round(baseTotal * (1 - couponApplied.discount_percent / 100)) : baseTotal;

  const canConfirm =
    listing &&
    name.trim() &&
    phone.trim().length >= 7 &&
    email.trim().includes("@") &&
    !submitting &&
    (multiDay ? rangeDays > 0 : !!slot);

  async function confirmBooking() {
    if (!listing) return;
    setError("");
    setSubmitting(true);
    const code = Math.random().toString(36).slice(2, 7).toUpperCase();

    if (multiDay) {
      if (rangeDays === 0) {
        setError("Pick a valid date range.");
        setSubmitting(false);
        return;
      }
      const groupId = crypto.randomUUID();
      const rows = rangeDates.map((d) => ({
        listing_id: listing.id,
        booking_date: d,
        slot_time: "FULL DAY",
        customer_name: name.trim(),
        customer_phone: phone.trim(),
        customer_email: email.trim(),
        code,
        booking_group_id: groupId,
        coupon_code: couponApplied?.code || null,
      }));
      const { error: err } = await supabase.from("bookings").insert(rows);
      if (err) {
        setError(err.code === "23505" ? "One or more of those days is already booked — pick a different range." : "Couldn't save your booking — please try again.");
        setSubmitting(false);
        return;
      }
      setTicket({
        vehicle: listing.name,
        type: listing.category,
        date: `${rangeStart} → ${rangeEnd}`,
        slot: `${rangeDays} ${tr("days")}`,
        name: name.trim(),
        phone: phone.trim(),
        email: email.trim(),
        price: discountedTotal,
        unit: "",
        tag: listing.tag,
        hours: null,
        code,
        multiDay: true,
      });
      setSubmitting(false);
      return;
    }

    const { error: err } = await supabase.from("bookings").insert({
      listing_id: listing.id,
      booking_date: date,
      slot_time: slot,
      customer_name: name.trim(),
      customer_phone: phone.trim(),
      customer_email: email.trim(),
      code,
      coupon_code: couponApplied?.code || null,
    });

    if (err) {
      if (err.code === "23505") {
        setError("That slot was just taken — pick another.");
        setTakenSlots((prev) => [...prev, slot]);
        setSlot(null);
      } else {
        setError("Couldn't save your booking — please try again.");
      }
      setSubmitting(false);
      return;
    }

    setTicket({
      vehicle: listing.name,
      type: listing.category,
      date,
      slot,
      name: name.trim(),
      phone: phone.trim(),
      email: email.trim(),
      price: discountedTotal,
      unit: listing.unit,
      tag: listing.tag,
      hours: listing.hours,
      code,
      multiDay: false,
    });
    setSubmitting(false);
  }

  async function submitReview(e) {
    e.preventDefault();
    if (!reviewForm.name.trim() || !selected) return;
    setReviewSubmitting(true);
    await supabase.from("reviews").insert({
      listing_id: selected.listingId,
      customer_name: reviewForm.name.trim(),
      rating: reviewForm.rating,
      comment: reviewForm.comment.trim() || null,
    });
    setReviewSubmitting(false);
    setReviewDone(true);
    setReviewForm({ name: "", rating: 5, comment: "" });
  }

  function waLink() {
    if (!ticket) return "#";
    const label = ticket.type === "tour" ? "Tour" : "Vehicle";
    const durationLine =
      ticket.type === "tour" && ticket.hours ? `%0ADuration: ${ticket.tag} (${ticket.hours} hrs)` : "";
    const priceLine = `%0ATotal: ₹${ticket.price}${ticket.unit || ""}`;
    const msg = `Hi ${BUSINESS.name}! I'd like to confirm my booking:%0A%0A${label}: ${ticket.vehicle}%0ADate: ${ticket.date}%0ATime: ${ticket.slot}${durationLine}${priceLine}%0AName: ${ticket.name}%0APhone: ${ticket.phone}%0ABooking code: ${ticket.code}`;
    return `https://wa.me/${BUSINESS.whatsapp}?text=${msg}`;
  }

  function resetFlow() {
    setTicket(null);
    setSelected(null);
    setSlot(null);
    setName("");
    setPhone("");
    setEmail("");
    setMultiDay(false);
    setCouponApplied(null);
    setCouponInput("");
  }

  const term = search.trim().toLowerCase();
  const matches = (l) => !term || l.name.toLowerCase().includes(term);
  const sortListings = (items) => {
    if (sortOrder === "priceAsc") return [...items].sort((a, b) => a.price - b.price);
    if (sortOrder === "priceDesc") return [...items].sort((a, b) => b.price - a.price);
    return items;
  };

  const categoryIcon = (t2, size = 16) =>
    t2 === "bike" ? <Bike size={size} /> : t2 === "car" ? <Car size={size} /> : t2 === "bus" ? <Bus size={size} /> : <Landmark size={size} />;

  return (
    <div className="font-body min-h-screen w-full" style={{ color: COLORS.text }}>
      {/* Navbar */}
      <header
        className="flex items-center gap-3 px-5 py-4 sticky top-0 z-20 flex-wrap"
        style={{ background: "rgba(20,24,28,0.75)", backdropFilter: "blur(14px)", borderBottom: `1px solid ${COLORS.border}` }}
      >
        <div className="flex items-center gap-2.5 shrink-0">
          <div
            className="w-9 h-9 rounded-xl flex items-center justify-center"
            style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, boxShadow: `0 4px 16px ${COLORS.glow}` }}
          >
            <Car size={18} color={COLORS.bg} strokeWidth={2.5} />
          </div>
          <span className="font-display text-xl tracking-wide hidden sm:block">{BUSINESS.name.toUpperCase()}</span>
        </div>
        <div className="relative flex-1 min-w-[140px] max-w-md">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder={tr("searchPlaceholder")}
            aria-label={tr("searchPlaceholder")}
            className="w-full pl-9 pr-3 py-2.5 rounded-full text-sm"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
          />
        </div>
        <div className="hidden sm:flex items-center gap-1.5 text-xs font-mono shrink-0" style={{ color: COLORS.muted }}>
          <MapPin size={13} />
          {BUSINESS.location}
        </div>
        <LanguageToggle />
        <ThemeToggle />
      </header>

      {/* Hero */}
      <section className="relative px-5 pt-14 pb-10 text-center overflow-hidden">
        <div
          className="absolute inset-0 z-0"
          style={{
            backgroundImage: `linear-gradient(180deg, rgba(20,24,28,0.55) 0%, ${COLORS.bg} 92%), url('https://commons.wikimedia.org/wiki/Special:FilePath/Konark_Sun_Temple_Front_view.jpg')`,
            backgroundSize: "cover",
            backgroundPosition: "center 30%",
          }}
        />
        <div className="relative z-10">
          <div
            className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full mb-4 font-mono text-[10px] tracking-[0.2em]"
            style={{ background: "rgba(20,24,28,0.55)", color: COLORS.accentBright, border: `1px solid rgba(245,183,0,0.35)`, backdropFilter: "blur(4px)" }}
          >
            <span className="w-1.5 h-1.5 rounded-full" style={{ background: COLORS.accentBright }} />
            {tr("tagline")}
          </div>
          <h1 className="font-display text-5xl sm:text-7xl leading-none" style={{ color: "#FFFFFF", textShadow: "0 2px 20px rgba(0,0,0,0.5)" }}>
            {tr("heroTitle1")} <span style={{ color: COLORS.accentBright }}>{tr("heroTitle2")}</span>
          </h1>
          <p className="mt-3 text-base" style={{ color: "#F2F0EA" }}>
            {tr("heroSubtitle")}
          </p>
        </div>
      </section>

      {/* Services overview — compact 2x2 summary strip, not a second hero */}
      <section className="px-5 pb-7 max-w-5xl mx-auto">
        <p className="font-mono text-xs tracking-widest mb-3 text-center" style={{ color: COLORS.muted }}>{tr("ourServices")}</p>
        <div className="grid grid-cols-2 gap-2">
          <a
            href="#tour"
            className="flex items-center gap-2.5 p-2.5 rounded-xl"
            style={{ background: `linear-gradient(160deg, ${COLORS.accentSoft}, ${COLORS.surface})`, border: `1px solid ${COLORS.accent}` }}
          >
            <Landmark size={18} color={COLORS.accent} className="shrink-0" />
            <p className="font-semibold text-xs leading-tight">{tr("serviceToursTitle")}</p>
          </a>
          <a
            href="#travel"
            className="flex items-center gap-2.5 p-2.5 rounded-xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Route size={18} color={COLORS.accent} className="shrink-0" />
            <p className="font-semibold text-xs leading-tight">{tr("travels")}</p>
          </a>
          <a
            href={`https://wa.me/${BUSINESS.whatsapp}?text=Hi! I'd like help planning a custom trip.`}
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2.5 p-2.5 rounded-xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Compass size={18} color={COLORS.accent} className="shrink-0" />
            <p className="font-semibold text-xs leading-tight">{tr("serviceCustomTitle")}</p>
          </a>
          <a
            href={`https://wa.me/${BUSINESS.whatsapp}?text=Hi! I'd like to enquire about group/corporate travel.`}
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2.5 p-2.5 rounded-xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Users size={18} color={COLORS.accent} className="shrink-0" />
            <p className="font-semibold text-xs leading-tight">{tr("serviceGroupTitle")}</p>
          </a>
        </div>
      </section>

      {/* Why Travel With Us — trust block */}
      <section className="px-5 pb-8 max-w-5xl mx-auto">
        <div
          className="rounded-3xl p-6 sm:p-8"
          style={{ background: `linear-gradient(160deg, ${COLORS.surface2}, ${COLORS.surface})`, border: `1px solid ${COLORS.border}` }}
        >
          <p className="font-mono text-xs tracking-[0.2em] mb-2" style={{ color: COLORS.accent }}>{tr("planYourJourney")}</p>
          <h2 className="font-display text-3xl sm:text-4xl mb-5 leading-tight">{tr("whyChooseTitle")}</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {[
              { icon: Route, label: tr("whyChoose1") },
              { icon: Check, label: tr("whyChoose2") },
              { icon: Star, label: tr("whyChoose3") },
              { icon: MessageCircle, label: tr("whyChoose4") },
            ].map((item, i) => (
              <div key={i} className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-full flex items-center justify-center shrink-0" style={{ background: COLORS.accentSoft }}>
                  <item.icon size={16} color={COLORS.accent} />
                </div>
                <span className="text-sm font-medium">{item.label}</span>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* About — narrative section with background photo */}
      <section className="relative px-5 py-14 mb-8 overflow-hidden">
        <div
          className="absolute inset-0 z-0"
          style={{
            backgroundImage: `linear-gradient(180deg, ${COLORS.bg} 0%, rgba(20,24,28,0.75) 40%, rgba(20,24,28,0.75) 60%, ${COLORS.bg} 100%), url('https://commons.wikimedia.org/wiki/Special:FilePath/Boat_ride_on_Chilika_Lake%2C_Balugaon%2C_Odisha%2C_India.jpg')`,
            backgroundSize: "cover",
            backgroundPosition: "center",
          }}
        />
        <div className="relative z-10 max-w-lg mx-auto text-center">
          <p className="font-mono text-xs tracking-[0.2em] mb-2" style={{ color: COLORS.accentBright }}>{tr("aboutTag")}</p>
          <h2 className="font-accent text-3xl sm:text-4xl mb-4" style={{ color: "#FFFFFF" }}>{tr("aboutHeading")}</h2>
          <p className="text-sm leading-relaxed" style={{ color: "#E8E4DC" }}>{tr("aboutBody")}</p>
        </div>
      </section>

      {/* Popular Destinations — decorative circular preview */}
      <section className="px-5 pb-8 max-w-5xl mx-auto text-center">
        <p className="font-mono text-xs tracking-widest mb-1" style={{ color: COLORS.muted }}>{tr("popularDestHeading")}</p>
        <p className="text-sm mb-5" style={{ color: COLORS.muted }}>{tr("popularDestSubtitle")}</p>
        <div className="flex justify-center gap-4 sm:gap-6 flex-wrap">
          {[
            { name: "Lingaraj Temple", url: "https://commons.wikimedia.org/wiki/Special:FilePath/Lingaraj_temple_Bhubaneswar.jpg" },
            { name: "Konark", url: "https://commons.wikimedia.org/wiki/Special:FilePath/Konark_Sun_Temple_Front_view.jpg" },
            { name: "Chilika Lake", url: "https://commons.wikimedia.org/wiki/Special:FilePath/Boat_ride_on_Chilika_Lake%2C_Balugaon%2C_Odisha%2C_India.jpg" },
            { name: "Nandankanan", url: "https://commons.wikimedia.org/wiki/Special:FilePath/White_tiger_at_Nandankanan%2C_Odisha_II.jpg" },
            { name: "Bhitarkanika", url: "https://commons.wikimedia.org/wiki/Special:FilePath/White_Crocodile_at_Bhitarkanika_National_Park.jpg" },
          ].map((d) => (
            <a key={d.name} href="#tour" className="flex flex-col items-center gap-2 w-20">
              <div
                className="w-20 h-20 rounded-full overflow-hidden"
                style={{ border: `2px solid ${COLORS.accent}`, boxShadow: `0 6px 18px ${COLORS.glow}` }}
              >
                <img src={d.url} alt={d.name} loading="lazy" className="w-full h-full object-cover" />
              </div>
              <span className="text-[11px] font-medium leading-tight">{d.name}</span>
            </a>
          ))}
        </div>
      </section>

      <div className="px-5 max-w-5xl mx-auto">
        <AdUnit slot={ADSENSE_SLOTS.belowServices} />
      </div>

      {/* Booking panel */}
      {selected && (
        <div ref={panelRef} style={{ scrollMarginTop: "72px" }} className="px-5 pb-2">
          {ticket ? (
            <TicketView ticket={ticket} waLink={waLink()} onReset={resetFlow} colors={COLORS} business={BUSINESS} tr={tr} />
          ) : (
            <div
              className="max-w-xl mx-auto rounded-2xl p-5"
              style={{ background: `linear-gradient(160deg, ${COLORS.surface}, ${COLORS.surface2})`, border: `1px solid ${COLORS.accent}`, boxShadow: `0 12px 32px ${COLORS.glow}` }}
            >
              <div className="flex items-center justify-between mb-4">
                <div>
                  <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>{tr("booking")}</p>
                  <p className="font-semibold">{listing ? listing.name : "..."}</p>
                </div>
                <button onClick={() => setSelected(null)} className="p-2 rounded-full" aria-label="Close" style={{ background: COLORS.surface2 }}>
                  <X size={16} color={COLORS.muted} />
                </button>
              </div>

              {isMultiDayEligible && (
                <label className="flex items-center gap-2 mb-4 text-sm cursor-pointer">
                  <input type="checkbox" checked={multiDay} onChange={(e) => setMultiDay(e.target.checked)} />
                  <CalendarRange size={14} color={COLORS.accent} />
                  {tr("multiDay")}
                </label>
              )}

              {multiDay ? (
                <>
                  <div className="grid grid-cols-2 gap-3 mb-4">
                    <div>
                      <label className="block font-mono text-xs mb-1.5" style={{ color: COLORS.muted }}>{tr("startDate")}</label>
                      <input
                        type="date"
                        value={rangeStart}
                        min={dateKey(days[0])}
                        onChange={(e) => setRangeStart(e.target.value)}
                        className="w-full px-3 py-2.5 rounded-lg text-sm"
                        style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                      />
                    </div>
                    <div>
                      <label className="block font-mono text-xs mb-1.5" style={{ color: COLORS.muted }}>{tr("endDate")}</label>
                      <input
                        type="date"
                        value={rangeEnd}
                        min={rangeStart}
                        onChange={(e) => setRangeEnd(e.target.value)}
                        className="w-full px-3 py-2.5 rounded-lg text-sm"
                        style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                      />
                    </div>
                  </div>
                  {rangeDays > 0 && (
                    <p className="text-sm mb-4 font-mono" style={{ color: COLORS.accent }}>
                      {tr("totalFor")} {rangeDays} {tr("days")}: ₹{discountedTotal}
                      {couponApplied && <span style={{ color: COLORS.muted }}> (₹{baseTotal} - {couponApplied.discount_percent}%)</span>}
                    </p>
                  )}
                </>
              ) : (
                <>
                  <p className="font-mono text-xs tracking-widest mb-2" style={{ color: COLORS.muted }}>{tr("selectDate")}</p>
                  <div className="flex gap-2 overflow-x-auto pb-2 mb-5">
                    {days.map((d) => {
                      const key = dateKey(d);
                      const active = date === key;
                      return (
                        <button
                          key={key}
                          onClick={() => setDate(key)}
                          className="flex flex-col items-center justify-center rounded-xl px-3.5 py-2 min-w-[56px] shrink-0"
                          style={
                            active
                              ? { background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, boxShadow: `0 6px 16px ${COLORS.glow}` }
                              : { background: COLORS.surface2, border: `1px solid ${COLORS.border}` }
                          }
                        >
                          <span className="font-mono text-[10px]" style={{ color: active ? COLORS.bg : COLORS.muted }}>{dayLabel(d)}</span>
                          <span className="font-display text-xl leading-none" style={{ color: active ? COLORS.bg : COLORS.text }}>{d.getDate()}</span>
                        </button>
                      );
                    })}
                  </div>

                  <p className="font-mono text-xs tracking-widest mb-2" style={{ color: COLORS.muted }}>
                    {selected.category === "tour" ? tr("selectPickupTime") : tr("selectTime")}
                  </p>
                  <div className="grid grid-cols-3 sm:grid-cols-6 gap-2 mb-5">
                    {loadingSlots
                      ? Array.from({ length: 6 }).map((_, i) => <div key={i} className="h-10 rounded-lg animate-pulse" style={{ background: COLORS.surface2 }} />)
                                      : SLOTS.map((s) => {
                          const isBooked = takenSlots.includes(s);
                          const isPast = isPastSlot(date, s);
                          const isDisabled = isBooked || isPast;
                          const active = slot === s;
                          return (
                            <button
                              key={s}
                              disabled={isDisabled}
                              onClick={() => setSlot(s)}
                              className="font-mono text-sm py-2.5 rounded-lg flex items-center justify-center gap-1.5"
                              style={{
                                background: isDisabled ? "transparent" : active ? `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})` : COLORS.surface2,
                                border: `1px solid ${isDisabled ? COLORS.border : active ? "transparent" : COLORS.border}`,
                                color: isDisabled ? COLORS.muted : active ? COLORS.bg : COLORS.text,
                                opacity: isDisabled ? 0.4 : 1,
                                textDecoration: isDisabled ? "line-through" : "none",
                                cursor: isDisabled ? "not-allowed" : "pointer",
                              }}
                            >
                              <Clock size={12} />
                              {s}
                            </button>
                          );
                        })}
                  </div>
                </>
              )}

              <div className="grid sm:grid-cols-2 gap-3 mb-3">
                <div className="relative">
                  <User size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                  <input placeholder={tr("fullName")} aria-label={tr("fullName")} value={name} onChange={(e) => setName(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
                </div>
                <div className="relative">
                  <Phone size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                  <input placeholder={tr("phoneNumber")} aria-label={tr("phoneNumber")} value={phone} onChange={(e) => setPhone(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
                </div>
              </div>
              <div className="relative mb-3">
                <Mail size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                <input type="email" placeholder={tr("emailAddress")} aria-label={tr("emailAddress")} value={email} onChange={(e) => setEmail(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
              </div>

              <div className="flex gap-2 mb-4">
                <div className="relative flex-1">
                  <Tag size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                  <input
                    placeholder={tr("couponCode")}
                    aria-label={tr("couponCode")}
                    value={couponInput}
                    onChange={(e) => setCouponInput(e.target.value)}
                    disabled={!!couponApplied}
                    className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text, opacity: couponApplied ? 0.6 : 1 }}
                  />
                </div>
                <button
                  onClick={applyCoupon}
                  disabled={couponChecking || !!couponApplied}
                  className="px-4 rounded-lg text-sm font-semibold shrink-0"
                  style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                >
                  {couponChecking ? <Loader2 className="animate-spin" size={14} /> : couponApplied ? `✓ ${couponApplied.discount_percent}%` : tr("apply")}
                </button>
              </div>
              {couponError && <p className="text-xs mb-3" style={{ color: COLORS.danger }}>{couponError}</p>}

              {error && <p className="text-xs mb-3" style={{ color: COLORS.danger }}>{error}</p>}

              <button
                disabled={!canConfirm}
                onClick={confirmBooking}
                className="w-full py-3.5 rounded-xl font-semibold flex items-center justify-center gap-2"
                style={{
                  background: canConfirm ? `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})` : COLORS.surface2,
                  color: canConfirm ? COLORS.bg : COLORS.muted,
                  boxShadow: canConfirm ? `0 10px 26px ${COLORS.glow}` : "none",
                }}
              >
                {submitting ? <Loader2 className="animate-spin" size={18} /> : <>{tr("confirmBooking")} <ChevronRight size={18} /></>}
              </button>
              <p className="flex items-center justify-center gap-1.5 text-xs mt-3" style={{ color: COLORS.muted }}>
                <ShieldCheck size={12} /> {tr("cancellationPolicy")}
              </p>

              {/* Reviews */}
              <div className="mt-6 pt-5" style={{ borderTop: `1px solid ${COLORS.border}` }}>
                <p className="font-mono text-xs tracking-widest mb-3" style={{ color: COLORS.muted }}>{tr("reviews")}</p>
                {panelReviews.length > 0 && (
                  <div className="space-y-3 mb-4 max-h-48 overflow-y-auto pr-1">
                    {panelReviews.map((r, i) => (
                      <div key={i} className="text-sm">
                        <div className="flex items-center gap-1.5">
                          {Array.from({ length: 5 }).map((_, si) => (
                            <Star key={si} size={12} fill={si < r.rating ? COLORS.accent : "none"} color={COLORS.accent} />
                          ))}
                          <span className="font-semibold text-xs ml-1">{r.customer_name}</span>
                        </div>
                        {r.comment && <p className="text-xs mt-0.5" style={{ color: COLORS.muted }}>{r.comment}</p>}
                      </div>
                    ))}
                  </div>
                )}
                {reviewDone ? (
                  <p className="text-xs" style={{ color: COLORS.whatsapp }}>{tr("reviewSubmitted")}</p>
                ) : (
                  <form onSubmit={submitReview} className="space-y-2">
                    <div className="flex gap-2">
                      <input
                        placeholder={tr("yourName")}
                        aria-label={tr("yourName")}
                        value={reviewForm.name}
                        onChange={(e) => setReviewForm({ ...reviewForm, name: e.target.value })}
                        className="flex-1 px-3 py-2 rounded-lg text-xs"
                        style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                      />
                      <div className="flex items-center gap-1 px-2 rounded-lg" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}` }}>
                        {Array.from({ length: 5 }).map((_, si) => (
                          <button type="button" key={si} onClick={() => setReviewForm({ ...reviewForm, rating: si + 1 })} aria-label={`${si + 1} star`}>
                            <Star size={14} fill={si < reviewForm.rating ? COLORS.accent : "none"} color={COLORS.accent} />
                          </button>
                        ))}
                      </div>
                    </div>
                    <input
                      placeholder={tr("yourReview")}
                      aria-label={tr("yourReview")}
                      value={reviewForm.comment}
                      onChange={(e) => setReviewForm({ ...reviewForm, comment: e.target.value })}
                      className="w-full px-3 py-2 rounded-lg text-xs"
                      style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                    />
                    <button
                      type="submit"
                      disabled={!reviewForm.name.trim() || reviewSubmitting}
                      className="text-xs font-semibold px-3 py-2 rounded-lg"
                      style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                    >
                      {reviewSubmitting ? <Loader2 className="animate-spin" size={12} /> : tr("submitReview")}
                    </button>
                  </form>
                )}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Category sections */}
      <main className="pb-16">
        {loadingListings ? (
          <div className="flex justify-center py-16">
            <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={28} />
          </div>
        ) : (
          <>
            <div className="flex items-center justify-end gap-2 px-5 max-w-5xl mx-auto mb-1">
              <label className="font-mono text-[11px]" style={{ color: COLORS.muted }} htmlFor="sortSelect">{tr("sortLabel")}:</label>
              <select
                id="sortSelect"
                value={sortOrder}
                onChange={(e) => setSortOrder(e.target.value)}
                className="text-xs font-mono px-2 py-1.5 rounded-md"
                style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
              >
                <option value="default">{tr("sortDefault")}</option>
                <option value="priceAsc">{tr("sortPriceLow")}</option>
                <option value="priceDesc">{tr("sortPriceHigh")}</option>
              </select>
            </div>

            {/* Tours — primary offering, hero-card treatment */}
            {(() => {
              const cat = TOUR_CATEGORY;
              const items = sortListings(allListings[cat.key].filter(matches));
              if (term && items.length === 0) return null;
              return (
                <section id={cat.key} className="pt-6 px-5" style={{ scrollMarginTop: "72px" }}>
                  <div className="max-w-5xl mx-auto mb-1">
                    <div className="flex items-center gap-2">
                      <cat.icon size={20} color={COLORS.accent} />
                      <h2 className="font-display text-2xl">{tr(cat.labelKey)}</h2>
                    </div>
                    <p className="text-xs mt-0.5" style={{ color: COLORS.muted }}>{tr("toursSectionSubtitle")}</p>
                  </div>
                  {items.length === 0 ? (
                    <p className="text-sm max-w-5xl mx-auto mt-3" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                  ) : (
                    <>
                      <div
                        ref={tourScrollRef}
                        onScroll={handleTourScroll}
                        className="flex gap-4 overflow-x-auto pb-1 pt-4 max-w-5xl mx-auto snap-x snap-mandatory sm:snap-none no-scrollbar"
                      >
                        {items.map((l) => (
                          <TourCard
                            key={l.id}
                            listing={l}
                            category={cat}
                            colors={COLORS}
                            stats={reviewStats[l.id]}
                            bookingCount={bookingCounts[l.id] || 0}
                            popularLabel={tr("popular")}
                            bookLabel={tr("book")}
                            selectedLabel={tr("selected")}
                            addToTripLabel={tr("addToTrip")}
                            addedToTripLabel={tr("addedToTrip")}
                            inTrip={isInTrip(l.id)}
                            onToggleTrip={() => toggleTrip(l, cat.key)}
                            selected={selected && selected.listingId === l.id}
                            onBook={() => chooseListing(cat.key, l.id)}
                            onCardClick={() => setDetailListing({ listing: l, category: cat })}
                          />
                        ))}
                      </div>
                      {items.length > 1 && (
                        <div className="flex gap-1.5 justify-center mt-3 sm:hidden" aria-hidden="true">
                          {items.map((_, i) => (
                            <span
                              key={i}
                              className="h-1.5 rounded-full transition-all"
                              style={{
                                width: i === activeTourIndex ? 16 : 6,
                                background: i === activeTourIndex ? COLORS.accent : COLORS.border,
                              }}
                            />
                          ))}
                        </div>
                      )}
                    </>
                  )}
                </section>
              );
            })()}

            {/* Packages — all-inclusive stay + food + sightseeing bundles */}
            {(() => {
              const cat = PACKAGE_CATEGORY;
              const items = sortListings(allListings[cat.key].filter(matches));
              if (term && items.length === 0) return null;
              return (
                <section id={cat.key} className="pt-8 px-5" style={{ scrollMarginTop: "72px" }}>
                  <div className="max-w-5xl mx-auto mb-1">
                    <div className="flex items-center gap-2">
                      <cat.icon size={20} color={COLORS.accent} />
                      <h2 className="font-display text-2xl">{tr(cat.labelKey)}</h2>
                    </div>
                    <p className="text-xs mt-0.5" style={{ color: COLORS.muted }}>{tr("packagesSectionSubtitle")}</p>
                  </div>
                  {items.length === 0 ? (
                    <p className="text-sm max-w-5xl mx-auto mt-3" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                  ) : (
                    <>
                      <div
                        ref={packageScrollRef}
                        onScroll={handlePackageScroll}
                        className="flex gap-4 overflow-x-auto pb-1 pt-4 max-w-5xl mx-auto snap-x snap-mandatory sm:snap-none no-scrollbar"
                      >
                        {items.map((l) => (
                          <TourCard
                            key={l.id}
                            listing={l}
                            category={cat}
                            colors={COLORS}
                            stats={reviewStats[l.id]}
                            bookingCount={bookingCounts[l.id] || 0}
                            popularLabel={tr("popular")}
                            bookLabel={tr("book")}
                            selectedLabel={tr("selected")}
                            addToTripLabel={tr("addToTrip")}
                            addedToTripLabel={tr("addedToTrip")}
                            inTrip={isInTrip(l.id)}
                            onToggleTrip={() => toggleTrip(l, cat.key)}
                            selected={selected && selected.listingId === l.id}
                            onBook={() => chooseListing(cat.key, l.id)}
                            onCardClick={() => setDetailListing({ listing: l, category: cat })}
                          />
                        ))}
                      </div>
                      {items.length > 1 && (
                        <div className="flex gap-1.5 justify-center mt-3 sm:hidden" aria-hidden="true">
                          {items.map((_, i) => (
                            <span
                              key={i}
                              className="h-1.5 rounded-full transition-all"
                              style={{
                                width: i === activePackageIndex ? 16 : 6,
                                background: i === activePackageIndex ? COLORS.accent : COLORS.border,
                              }}
                            />
                          ))}
                        </div>
                      )}
                    </>
                  )}
                </section>
              );
            })()}

            {/* Travels — flexible chauffeur-driven roaming, not a fixed itinerary */}
            {(() => {
              const cat = TRAVEL_CATEGORY;
              const allItems = sortListings(allListings[cat.key].filter(matches));
              if (term && allItems.length === 0) return null;
              const isExpanded = !!expandedCats[cat.key];
              const items = isExpanded ? allItems : allItems.slice(0, 3);
              return (
                <section id={cat.key} className="pt-8 px-5" style={{ scrollMarginTop: "72px" }}>
                  <div className="max-w-5xl mx-auto">
                    <div className="flex items-center justify-between mb-1">
                      <div className="flex items-center gap-2">
                        <cat.icon size={20} color={COLORS.accent} />
                        <h2 className="font-display text-2xl">{tr(cat.labelKey)}</h2>
                      </div>
                      {allItems.length > 3 && (
                        <button onClick={() => toggleExpanded(cat.key)} className="text-xs font-mono" style={{ color: COLORS.accent }}>
                          {isExpanded ? tr("showLess") : `${tr("viewAll")} (${allItems.length})`}
                        </button>
                      )}
                    </div>
                    <p className="text-xs mb-4" style={{ color: COLORS.muted }}>{tr("travelsSectionSubtitle")}</p>
                    {items.length === 0 ? (
                      <p className="text-sm" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                    ) : (
                      <div className="grid grid-cols-3 gap-2 sm:gap-3">
                        {items.map((l) => (
                          <PhotoCard
                            key={l.id}
                            listing={l}
                            category={cat}
                            colors={COLORS}
                            stats={reviewStats[l.id]}
                            bookingCount={bookingCounts[l.id] || 0}
                            popularLabel={tr("popular")}
                            bookLabel={tr("book")}
                            selectedLabel={tr("selected")}
                            addToTripLabel={tr("addToTrip")}
                            addedToTripLabel={tr("addedToTrip")}
                            inTrip={isInTrip(l.id)}
                            onToggleTrip={() => toggleTrip(l, cat.key)}
                            selected={selected && selected.listingId === l.id}
                            onBook={() => chooseListing(cat.key, l.id)}
                            onCardClick={() => setDetailListing({ listing: l, category: cat })}
                            layout="grid"
                          />
                        ))}
                      </div>
                    )}
                  </div>
                </section>
              );
            })()}

            <div className="px-5 max-w-5xl mx-auto">
              <AdUnit slot={ADSENSE_SLOTS.midPage} />
            </div>

            {/* Bikes, Cars, Buses — plain fleet listing, no separate "service" framing */}
            <div className="pt-10 px-5 max-w-5xl mx-auto text-center" style={{ borderTop: `1px solid ${COLORS.border}` }}>
              <p className="font-mono text-xs tracking-widest mb-1.5 mt-4" style={{ color: COLORS.accent }}>{tr("ourFleetHeading")}</p>
              <p className="text-sm max-w-md mx-auto" style={{ color: COLORS.muted }}>{tr("ourFleetSubtitle")}</p>
            </div>
            {VEHICLE_CATEGORIES.map((cat) => {
              const allItems = sortListings(allListings[cat.key].filter(matches));
              if (term && allItems.length === 0) return null;
              const isExpanded = !!expandedCats[cat.key];
              const items = isExpanded ? allItems : allItems.slice(0, 3);
              return (
                <section id={cat.key} key={cat.key} className="pt-8 px-5" style={{ scrollMarginTop: "72px" }}>
                  <div className="max-w-5xl mx-auto">
                    <div className="flex items-center justify-between mb-3">
                      <div className="flex items-center gap-2">
                        <cat.icon size={20} color={COLORS.accent} />
                        <h2 className="font-display text-2xl">{tr(cat.labelKey)}</h2>
                      </div>
                      {allItems.length > 3 && (
                        <button onClick={() => toggleExpanded(cat.key)} className="text-xs font-mono" style={{ color: COLORS.accent }}>
                          {isExpanded ? tr("showLess") : `${tr("viewAll")} (${allItems.length})`}
                        </button>
                      )}
                    </div>
                    {items.length === 0 ? (
                      <p className="text-sm" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                    ) : (
                      <div className="grid grid-cols-3 gap-2 sm:gap-3">
                        {items.map((l) => (
                          <PhotoCard
                            key={l.id}
                            listing={l}
                            category={cat}
                            colors={COLORS}
                            stats={reviewStats[l.id]}
                            bookingCount={bookingCounts[l.id] || 0}
                            popularLabel={tr("popular")}
                            layout="grid"
                            bookable={false}
                          />
                        ))}
                      </div>
                    )}
                  </div>
                </section>
              );
            })}
          </>
        )}
      </main>

      {/* Testimonials — real approved reviews, only shown once some exist */}
      {testimonials.length > 0 && (
        <section className="relative px-5 py-14 overflow-hidden">
          <div
            className="absolute inset-0 z-0"
            style={{
              backgroundImage: `linear-gradient(180deg, ${COLORS.bg} 0%, rgba(20,24,28,0.8) 35%, rgba(20,24,28,0.8) 65%, ${COLORS.bg} 100%), url('https://commons.wikimedia.org/wiki/Special:FilePath/Similipal.jpg')`,
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          />
          <div className="relative z-10 max-w-5xl mx-auto">
            <p className="font-mono text-xs tracking-widest mb-5 text-center" style={{ color: COLORS.accentBright }}>{tr("testimonialsHeading")}</p>
            <div className="flex gap-4 overflow-x-auto pb-2 snap-x snap-mandatory no-scrollbar">
              {testimonials.map((t, i) => (
                <div
                  key={i}
                  className="shrink-0 w-72 snap-start rounded-2xl p-5"
                  style={{ background: "rgba(28,34,40,0.85)", border: "1px solid rgba(245,183,0,0.2)", backdropFilter: "blur(6px)" }}
                >
                  <div className="flex items-center gap-1 mb-2">
                    {Array.from({ length: 5 }).map((_, si) => (
                      <Star key={si} size={12} fill={si < t.rating ? COLORS.accentBright : "none"} color={COLORS.accentBright} />
                    ))}
                  </div>
                  <p className="font-accent text-base leading-relaxed mb-3" style={{ color: "#F2F0EA" }}>"{t.comment}"</p>
                  <p className="text-xs font-mono" style={{ color: "#C9C2B4" }}>{t.customer_name} · {t.listings?.name}</p>
                </div>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Why RideLine — detailed, substantive content instead of just marketing copy */}
      <section className="px-5 py-14 max-w-3xl mx-auto">
        <h2 className="font-display text-3xl sm:text-4xl text-center mb-10">{tr("whySection1Heading")}</h2>
        <div className="flex flex-col gap-8">
          {[
            { icon: Compass, title: tr("why1Title"), body: tr("why1Body") },
            { icon: Clock, title: tr("why2Title"), body: tr("why2Body") },
            { icon: Tag, title: tr("why3Title"), body: tr("why3Body") },
            { icon: Route, title: tr("why4Title"), body: tr("why4Body") },
            { icon: MessageCircle, title: tr("why5Title"), body: tr("why5Body") },
          ].map((item, i) => (
            <div key={i} className="flex gap-4">
              <div className="w-11 h-11 rounded-xl flex items-center justify-center shrink-0" style={{ background: COLORS.accentSoft }}>
                <item.icon size={19} color={COLORS.accent} />
              </div>
              <div>
                <h3 className="font-semibold text-lg mb-1.5">{item.title}</h3>
                <p className="text-sm leading-relaxed" style={{ color: COLORS.muted }}>{item.body}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      <section className="px-5 py-14 max-w-3xl mx-auto" style={{ borderTop: `1px solid ${COLORS.border}` }}>
        <h2 className="font-display text-3xl sm:text-4xl text-center mb-10 mt-4">{tr("whySection2Heading")}</h2>
        <div className="flex flex-col gap-8">
          {[
            { icon: Landmark, title: tr("help1Title"), body: tr("help1Body") },
            { icon: Users, title: tr("help2Title"), body: tr("help2Body") },
            { icon: CalendarRange, title: tr("help3Title"), body: tr("help3Body") },
            { icon: MessageCircle, title: tr("help4Title"), body: tr("help4Body") },
          ].map((item, i) => (
            <div key={i} className="flex gap-4">
              <div className="w-11 h-11 rounded-xl flex items-center justify-center shrink-0" style={{ background: COLORS.accentSoft }}>
                <item.icon size={19} color={COLORS.accent} />
              </div>
              <div>
                <h3 className="font-semibold text-lg mb-1.5">{item.title}</h3>
                <p className="text-sm leading-relaxed" style={{ color: COLORS.muted }}>{item.body}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      <div className="px-5 max-w-5xl mx-auto">
        <AdUnit slot={ADSENSE_SLOTS.footer} />
      </div>
      
      {/* Footer */}
      <footer className="relative pt-12 pb-8 overflow-hidden">
        <div
          className="absolute inset-0 z-0"
          style={{
            backgroundImage: `linear-gradient(180deg, ${COLORS.bg} 0%, rgba(14,17,20,0.94) 16%, rgba(14,17,20,0.94) 100%), url('https://commons.wikimedia.org/wiki/Special:FilePath/Lingaraj_temple_Bhubaneswar.jpg')`,
            backgroundSize: "cover",
            backgroundPosition: "center 20%",
          }}
        />
        <div className="relative z-10">
        <div className="px-6 max-w-5xl mx-auto grid grid-cols-1 sm:grid-cols-2 gap-10 mb-10">
          <div>
            <p className="font-mono text-xs tracking-widest mb-3" style={{ color: COLORS.accentBright }}>{tr("footerQuickLinks")}</p>
            <div className="flex flex-col gap-2 text-sm">
              <a href="#tour" style={{ color: "#D8D3C7" }}>{tr("tours")}</a>
              <a href="#package" style={{ color: "#D8D3C7" }}>{tr("packages")}</a>
              <a href="#travel" style={{ color: "#D8D3C7" }}>{tr("travels")}</a>
              <a href="/lookup" className="flex items-center gap-1.5" style={{ color: "#D8D3C7" }}>
                <ClipboardList size={13} /> {tr("checkBooking")}
              </a>
            </div>
          </div>
          <div>
            <p className="font-mono text-xs tracking-widest mb-3" style={{ color: COLORS.accentBright }}>{tr("footerFindUs")}</p>
            <div className="rounded-xl overflow-hidden" style={{ border: "1px solid rgba(255,255,255,0.15)", height: 160 }}>
              <iframe
                title="Location map"
                width="100%"
                height="100%"
                style={{ border: 0, filter: "invert(90%) hue-rotate(180deg)" }}
                loading="lazy"
                src={`https://www.google.com/maps?q=${encodeURIComponent(BUSINESS.location)}&output=embed`}
              />
            </div>
            <p className="flex items-center gap-1.5 text-xs mt-2" style={{ color: "#D8D3C7" }}>
              <MapPin size={12} /> {BUSINESS.location}
            </p>
          </div>
        </div>

        <div className="flex flex-col items-center gap-5 px-6">
          <p className="font-mono text-xs tracking-widest" style={{ color: "#D8D3C7" }}>{tr("questionsReachUs")}</p>
          <div className="flex gap-3 flex-wrap justify-center">
            <a href={`https://wa.me/${BUSINESS.whatsapp}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: "rgba(255,255,255,0.08)", border: "1px solid rgba(255,255,255,0.15)", color: "#F2F0EA" }}>
              <MessageCircle size={16} color={COLORS.whatsapp} /> WhatsApp
            </a>
            <a href={`https://instagram.com/${BUSINESS.instagram}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: "rgba(255,255,255,0.08)", border: "1px solid rgba(255,255,255,0.15)", color: "#F2F0EA" }}>
              <Instagram size={16} color={COLORS.accentBright} /> Instagram
            </a>
            <a href={`https://facebook.com/${BUSINESS.facebook}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: "rgba(255,255,255,0.08)", border: "1px solid rgba(255,255,255,0.15)", color: "#F2F0EA" }}>
              <Facebook size={16} color={COLORS.accentBright} /> Facebook
            </a>
          </div>
          <a href="/admin/login" className="text-xs font-mono" style={{ color: "rgba(216,211,199,0.4)" }}>{tr("admin")}</a>
          <p className="text-[11px] font-mono text-center" style={{ color: "rgba(216,211,199,0.6)" }}>
            © {new Date().getFullYear()} {BUSINESS.name}. {tr("allRightsReserved")}
          </p>
        </div>
        </div>
      </footer>

      {/* Floating Trip Builder button */}
      {myTrip.length > 0 && !tripPanelOpen && (
        <button
          onClick={() => setTripPanelOpen(true)}
          className="fixed bottom-5 right-5 z-30 flex items-center gap-2 px-5 py-3.5 rounded-full font-semibold text-sm"
          style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, color: COLORS.bg, boxShadow: `0 12px 30px ${COLORS.glow}` }}
        >
          <Briefcase size={16} /> {tr("myTrip")} ({myTrip.length})
        </button>
      )}

      {tripPanelOpen && (
        <div className="fixed inset-0 z-40 flex items-end sm:items-center justify-center p-0 sm:p-6" style={{ background: "rgba(0,0,0,0.6)" }}>
          <div
            className="w-full sm:max-w-md max-h-[85vh] overflow-y-auto rounded-t-3xl sm:rounded-3xl p-5"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-display text-2xl flex items-center gap-2"><Briefcase size={18} color={COLORS.accent} /> {tr("myTrip")}</h2>
              <button onClick={() => { setTripPanelOpen(false); setTripSent(false); }} aria-label="Close">
                <X size={18} color={COLORS.muted} />
              </button>
            </div>

            {tripSent ? (
              <p className="text-sm py-6 text-center" style={{ color: COLORS.whatsapp }}>{tr("tripRequestSent")}</p>
            ) : myTrip.length === 0 ? (
              <p className="text-sm" style={{ color: COLORS.muted }}>{tr("tripEmpty")}</p>
            ) : (
              <>
                <div className="space-y-2 mb-5">
                  {myTrip.map((item) => (
                    <div key={item.listingId} className="flex items-center justify-between p-3 rounded-lg" style={{ background: COLORS.surface2 }}>
                      <div>
                        <p className="text-sm font-semibold">{item.name}</p>
                        <p className="font-mono text-xs" style={{ color: COLORS.muted }}>₹{item.price}{item.unit}</p>
                      </div>
                      <button onClick={() => removeFromTrip(item.listingId)} aria-label={tr("removeFromTrip")}>
                        <Trash2 size={15} color={COLORS.danger} />
                      </button>
                    </div>
                  ))}
                </div>
                <form onSubmit={sendTripRequest} className="space-y-2.5">
                  <input
                    placeholder={tr("fullName")}
                    value={tripForm.name}
                    onChange={(e) => setTripForm({ ...tripForm, name: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-lg text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                  />
                  <input
                    placeholder={tr("phoneNumber")}
                    value={tripForm.phone}
                    onChange={(e) => setTripForm({ ...tripForm, phone: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-lg text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                  />
                  <input
                    type="email"
                    placeholder={tr("emailAddress")}
                    value={tripForm.email}
                    onChange={(e) => setTripForm({ ...tripForm, email: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-lg text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                  />
                  <button
                    type="submit"
                    disabled={tripSubmitting || !tripForm.name.trim() || !tripForm.phone.trim()}
                    className="w-full py-3.5 rounded-xl font-semibold flex items-center justify-center gap-2"
                    style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, color: COLORS.bg }}
                  >
                    {tripSubmitting ? <Loader2 className="animate-spin" size={16} /> : tr("sendTripRequest")}
                  </button>
                </form>
              </>
            )}
          </div>
        </div>
      )}

      {/* Tour detail popup */}
      {detailListing && (
        <div className="fixed inset-0 z-40 flex items-end sm:items-center justify-center p-0 sm:p-6" style={{ background: "rgba(0,0,0,0.6)" }} onClick={() => setDetailListing(null)}>
          <div
            className="w-full sm:max-w-lg max-h-[85vh] overflow-y-auto rounded-t-3xl sm:rounded-3xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="h-48 relative flex items-center justify-center overflow-hidden" style={{ background: `linear-gradient(135deg, ${detailListing.category.tint}, ${COLORS.surface2})` }}>
              {detailListing.listing.image_url ? (
                <img src={detailListing.listing.image_url} alt={detailListing.listing.name} className="w-full h-full object-cover" />
              ) : (
                <detailListing.category.icon size={54} color={COLORS.accent} />
              )}
              <button
                onClick={() => setDetailListing(null)}
                aria-label="Close"
                className="absolute top-3 right-3 w-8 h-8 rounded-full flex items-center justify-center"
                style={{ background: "rgba(20,24,28,0.75)", backdropFilter: "blur(4px)" }}
              >
                <X size={16} color="#F2F0EA" />
              </button>
            </div>
            <div className="p-5">
              <div className="flex items-center justify-between mb-1">
                <h2 className="font-display text-2xl leading-tight pr-3">{detailListing.listing.name}</h2>
              </div>
              <p className="font-mono text-sm mb-1">
                <span style={{ color: COLORS.accent }}>₹{detailListing.listing.price}</span>
                <span style={{ color: COLORS.muted }}>{detailListing.listing.unit}</span>
              </p>
              <p className="font-mono text-xs mb-4" style={{ color: COLORS.muted }}>
                {detailListing.listing.tag}{detailListing.listing.hours ? ` · ${detailListing.listing.hours}h` : ""}
              </p>

              {(() => {
                const localizedDescription =
                  (lang !== "en" && detailListing.listing[`description_${lang}`]) || detailListing.listing.description;
                const localizedRequirements =
                  (lang !== "en" && detailListing.listing[`requirements_${lang}`]) || detailListing.listing.requirements;
                return (
                  <>
                    {localizedDescription && (
                      <div className="mb-4">
                        <p className="font-mono text-xs tracking-widest mb-1.5" style={{ color: COLORS.muted }}>{tr("aboutThisTour")}</p>
                        <p className="text-sm leading-relaxed" style={{ color: COLORS.text }}>{localizedDescription}</p>
                      </div>
                    )}
                    {localizedRequirements && (
                      <div className="mb-4">
                        <p className="font-mono text-xs tracking-widest mb-1.5" style={{ color: COLORS.muted }}>{tr("whatToKnow")}</p>
                        <p className="text-sm leading-relaxed" style={{ color: COLORS.text }}>{localizedRequirements}</p>
                      </div>
                    )}
                  </>
                );
              })()}

              <p className="flex items-center gap-1.5 text-xs mb-5" style={{ color: COLORS.muted }}>
                <ShieldCheck size={12} /> {tr("cancellationPolicy")}
              </p>

              <button
                onClick={() => {
                  chooseListing(detailListing.category.key, detailListing.listing.id);
                  setDetailListing(null);
                }}
                className="w-full py-3.5 rounded-xl font-semibold flex items-center justify-center gap-2"
                style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, color: COLORS.bg, boxShadow: `0 10px 26px ${COLORS.glow}` }}
              >
                {tr("bookNow")} <ChevronRight size={18} />
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function PhotoCard({ listing, category, colors, stats, bookingCount, popularLabel, bookLabel, selectedLabel, addToTripLabel, addedToTripLabel, inTrip, onToggleTrip, selected, onBook, onCardClick, layout = "scroll", bookable = true }) {
  const Icon = category.icon;
  const isPopular = bookingCount >= 3;
  const isGrid = layout === "grid";
  return (
    <div
      onClick={onCardClick}
      role={onCardClick ? "button" : undefined}
      tabIndex={onCardClick ? 0 : undefined}
      onKeyDown={onCardClick ? (e) => { if (e.key === "Enter") onCardClick(); } : undefined}
      className={`${isGrid ? "w-full" : "shrink-0 w-52 sm:w-56"} rounded-2xl overflow-hidden flex flex-col ${onCardClick ? "cursor-pointer" : ""}`}
      style={{ background: colors.surface, border: `1px solid ${selected ? colors.accent : colors.border}`, boxShadow: selected ? `0 8px 24px ${colors.glow}` : "0 2px 8px rgba(0,0,0,0.15)" }}
    >
      <div className="h-28 relative flex items-center justify-center overflow-hidden" style={{ background: `linear-gradient(135deg, ${category.tint}, ${colors.surface2})` }}>
        {listing.image_url ? (
          <img src={listing.image_url} alt={listing.name} loading="lazy" decoding="async" className="w-full h-full object-cover relative z-10" />
        ) : (
          <>
            <div className="absolute inset-0" style={{ opacity: 0.14 }}>
              <Icon size={26} color={colors.text} style={{ position: "absolute", top: 8, left: 10, transform: "rotate(-12deg)" }} />
              <Icon size={22} color={colors.text} style={{ position: "absolute", bottom: 10, left: 46, transform: "rotate(8deg)" }} />
              <Icon size={30} color={colors.text} style={{ position: "absolute", top: 18, right: 14, transform: "rotate(15deg)" }} />
              <Icon size={20} color={colors.text} style={{ position: "absolute", bottom: 14, right: 50, transform: "rotate(-10deg)" }} />
            </div>
            <Icon size={38} color={colors.accent} style={{ position: "relative", filter: `drop-shadow(0 2px 8px ${colors.glow})` }} />
          </>
        )}
        {bookable && (
          <button
            onClick={(e) => { e.stopPropagation(); onToggleTrip(); }}
            aria-label={inTrip ? addedToTripLabel : addToTripLabel}
            title={inTrip ? addedToTripLabel : addToTripLabel}
            className="absolute top-2 left-2 z-10 w-7 h-7 rounded-full flex items-center justify-center"
            style={{ background: inTrip ? colors.accent : "rgba(20,24,28,0.75)", backdropFilter: "blur(4px)" }}
          >
            {inTrip ? <Check size={14} color={colors.bg} /> : <Plus size={14} color="#F2F0EA" />}
          </button>
        )}
        <span className="absolute top-2 right-2 font-mono text-[10px] px-2 py-1 rounded-full z-10" style={{ background: "rgba(20,24,28,0.75)", color: "#F2F0EA", backdropFilter: "blur(4px)" }}>
          {listing.tag}{listing.hours ? ` · ${listing.hours}h` : ""}
        </span>
        <div className="absolute bottom-2 left-2 right-2 flex items-center justify-between z-10">
          {stats && stats.review_count > 0 ? (
            <span className="font-mono text-[10px] px-2 py-1 rounded-full flex items-center gap-1" style={{ background: "rgba(20,24,28,0.75)", color: "#F2F0EA", backdropFilter: "blur(4px)" }}>
              <Star size={10} fill={colors.accent} color={colors.accent} /> {stats.avg_rating} ({stats.review_count})
            </span>
          ) : <span />}
          {isPopular && (
            <span className="font-mono text-[10px] px-2 py-1 rounded-full" style={{ background: colors.accent, color: colors.bg }}>
              {popularLabel}
            </span>
          )}
        </div>
      </div>
      <div className={`${isGrid ? "p-3" : "p-3.5"} flex flex-col ${bookable ? "flex-1" : ""}`}>
        <p className="font-semibold text-sm leading-tight mb-1.5 line-clamp-2" style={{ color: colors.text }}>{listing.name}</p>
        <p className={`font-mono text-sm ${bookable ? "mb-3" : ""}`}>
          <span style={{ color: colors.accent }}>₹{listing.price}</span>
          {bookable && <span style={{ color: colors.muted }}>{listing.unit}</span>}
        </p>
        {bookable && (
          <button
            onClick={(e) => { e.stopPropagation(); onBook(); }}
            className="mt-auto w-full py-2 rounded-lg text-sm font-semibold"
            style={{
              background: selected ? `linear-gradient(135deg, ${colors.accent}, ${colors.accentBright})` : colors.surface2,
              color: selected ? colors.bg : colors.text,
              border: selected ? "none" : `1px solid ${colors.border}`,
            }}
          >
            {selected ? selectedLabel : bookLabel}
          </button>
        )}
      </div>
    </div>
  );
}

function TourCard({ listing, category, colors, stats, bookingCount, popularLabel, bookLabel, selectedLabel, addToTripLabel, addedToTripLabel, inTrip, onToggleTrip, selected, onBook, onCardClick }) {
  const Icon = category.icon;
  const isPopular = bookingCount >= 3;
  return (
    <div
      onClick={onCardClick}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => { if (e.key === "Enter") onCardClick(); }}
      className="shrink-0 rounded-2xl overflow-hidden flex flex-col snap-start cursor-pointer"
      style={{
        width: "86%",
        maxWidth: 340,
        background: colors.surface,
        border: `1px solid ${selected ? colors.accent : colors.border}`,
        boxShadow: selected ? `0 8px 24px ${colors.glow}` : "0 4px 16px rgba(0,0,0,0.18)",
      }}
    >
      <div className="h-44 relative flex items-center justify-center overflow-hidden" style={{ background: `linear-gradient(135deg, ${category.tint}, ${colors.surface2})` }}>
        {listing.image_url ? (
          <img src={listing.image_url} alt={listing.name} loading="lazy" decoding="async" className="w-full h-full object-cover relative z-10" />
        ) : (
          <>
            <div className="absolute inset-0" style={{ opacity: 0.14 }}>
              <Icon size={30} color={colors.text} style={{ position: "absolute", top: 10, left: 14, transform: "rotate(-12deg)" }} />
              <Icon size={24} color={colors.text} style={{ position: "absolute", bottom: 14, left: 56, transform: "rotate(8deg)" }} />
              <Icon size={34} color={colors.text} style={{ position: "absolute", top: 22, right: 18, transform: "rotate(15deg)" }} />
              <Icon size={22} color={colors.text} style={{ position: "absolute", bottom: 18, right: 60, transform: "rotate(-10deg)" }} />
            </div>
            <Icon size={46} color={colors.accent} style={{ position: "relative", filter: `drop-shadow(0 2px 8px ${colors.glow})` }} />
          </>
        )}
        {/* Duration badge, overlaid on the photo */}
        <span className="absolute top-2.5 left-2.5 font-mono text-[10px] px-2.5 py-1 rounded-full z-10" style={{ background: "rgba(20,24,28,0.75)", color: "#F2F0EA", backdropFilter: "blur(4px)" }}>
          {listing.tag}{listing.hours ? ` · ${listing.hours}h` : ""}
        </span>
        {/* Save-for-trip button, labeled */}
        <button
          onClick={(e) => { e.stopPropagation(); onToggleTrip(); }}
          aria-label={inTrip ? addedToTripLabel : addToTripLabel}
          title={inTrip ? addedToTripLabel : addToTripLabel}
          className="absolute top-2.5 right-2.5 z-10 w-8 h-8 rounded-full flex items-center justify-center"
          style={{ background: inTrip ? colors.accent : "rgba(20,24,28,0.75)", backdropFilter: "blur(4px)" }}
        >
          {inTrip ? <Check size={15} color={colors.bg} /> : <Plus size={15} color="#F2F0EA" />}
        </button>
        {isPopular && (
          <span className="absolute bottom-2.5 left-2.5 font-mono text-[10px] px-2.5 py-1 rounded-full z-10" style={{ background: colors.accent, color: colors.bg }}>
            {popularLabel}
          </span>
        )}
      </div>
      <div className="p-4 flex flex-col flex-1">
        <p className="font-semibold text-base leading-tight mb-1.5" style={{ color: colors.text }}>{listing.name}</p>
        {stats && stats.review_count > 0 && (
          <div className="flex items-center gap-1 text-xs mb-3" style={{ color: colors.muted }}>
            <Star size={12} fill={colors.accent} color={colors.accent} />
            {stats.avg_rating} · {stats.review_count} {stats.review_count === 1 ? "review" : "reviews"}
          </div>
        )}
        <div className="mt-auto flex items-center justify-between gap-3">
          <p className="font-mono text-base">
            <span style={{ color: colors.accent }}>₹{listing.price}</span>
            <span className="text-sm" style={{ color: colors.muted }}>{listing.unit}</span>
          </p>
          <button
            onClick={(e) => { e.stopPropagation(); onBook(); }}
            className="py-2 px-5 rounded-lg text-sm font-semibold shrink-0"
            style={{
              background: selected ? `linear-gradient(135deg, ${colors.accent}, ${colors.accentBright})` : colors.surface2,
              color: selected ? colors.bg : colors.text,
              border: selected ? "none" : `1px solid ${colors.border}`,
            }}
          >
            {selected ? selectedLabel : bookLabel}
          </button>
        </div>
      </div>
    </div>

  );
}

function TicketView({ ticket, waLink, onReset, colors, business, tr }) {
  return (
    <div className="max-w-md mx-auto animate-fade-up">
      <div className="rounded-3xl overflow-hidden mx-auto" style={{ background: `linear-gradient(160deg, ${colors.surface}, ${colors.surface2})`, border: `1px solid ${colors.border}`, boxShadow: `0 20px 50px rgba(0,0,0,0.4)` }}>
        <div className="p-6 flex items-center gap-3" style={{ background: `linear-gradient(135deg, rgba(245,183,0,0.18), rgba(245,183,0,0.04))` }}>
          <div className="w-9 h-9 rounded-full flex items-center justify-center" style={{ background: `linear-gradient(135deg, ${colors.accent}, ${colors.accentBright})`, boxShadow: `0 4px 14px ${colors.glow}` }}>
            <Check size={18} color={colors.bg} strokeWidth={3} />
          </div>
          <span className="font-display text-3xl">{ticket.multiDay ? "TRIP RESERVED" : ticket.type === "tour" ? "SEAT RESERVED" : "SLOT RESERVED"}</span>
        </div>
        <div className="px-6 py-5 font-mono text-sm space-y-3" style={{ color: colors.text }}>
          <Row label={ticket.type === "tour" ? "PACKAGE" : "VEHICLE"} value={ticket.vehicle} colors={colors} />
          <Row label="DATE" value={ticket.date} colors={colors} />
          <Row label={ticket.multiDay ? "DURATION" : "TIME"} value={ticket.slot} colors={colors} />
          <Row label="TOTAL" value={`₹${ticket.price}${ticket.unit || ""}`} colors={colors} />
          {ticket.type === "tour" && ticket.hours && <Row label="INFO" value={`${ticket.tag} · ${ticket.hours} hrs`} colors={colors} />}
          <Row label="NAME" value={ticket.name} colors={colors} />
          <Row label="PHONE" value={ticket.phone} colors={colors} />
          <Row label="EMAIL" value={ticket.email} colors={colors} />
        </div>
        <div className="relative h-0 border-t border-dashed" style={{ borderColor: colors.border }}>
          <div className="absolute -left-3 -top-3 w-6 h-6 rounded-full" style={{ background: colors.bg }} />
          <div className="absolute -right-3 -top-3 w-6 h-6 rounded-full" style={{ background: colors.bg }} />
        </div>
        <div className="px-6 py-5 flex items-center justify-between">
          <span className="text-xs font-mono" style={{ color: colors.muted }}>CODE</span>
          <span className="font-display text-3xl tracking-[0.15em]" style={{ color: colors.accent }}>{ticket.code}</span>
        </div>
        <div className="flex justify-center pb-6">
          <div className="p-2 rounded-xl" style={{ background: "#fff" }}>
            <img
              src={`https://api.qrserver.com/v1/create-qr-code/?size=140x140&data=${encodeURIComponent(`${business.name} booking ${ticket.code}`)}`}
              alt="Booking QR code"
              width="140"
              height="140"
              loading="lazy"
            />
          </div>
        </div>
      </div>
      <p className="text-center text-sm mt-6" style={{ color: colors.muted }}>Send this to {business.name} on WhatsApp to finalize pickup details.</p>
      <a href={waLink} target="_blank" rel="noreferrer" className="w-full mt-4 py-4 rounded-xl font-semibold flex items-center justify-center gap-2" style={{ background: colors.whatsapp, color: "#0B1A0F", boxShadow: "0 10px 30px rgba(37,211,102,0.3)" }}>
        <MessageCircle size={18} /> Confirm via WhatsApp
      </a>
      <button onClick={onReset} className="w-full mt-3 py-3.5 rounded-xl text-sm font-medium" style={{ background: "transparent", border: `1px solid ${colors.border}`, color: colors.muted }}>
        Book another slot
      </button>
    </div>
  );
}

function Row({ label, value, colors }) {
  return (
    <div className="flex items-center justify-between">
      <span style={{ color: colors.muted }}>{label}</span>
      <span>{value}</span>
    </div>
  );
}

FILEEOF

echo "Footer contrast fixed, long-form content added, vehicle unit display cleaned up."
