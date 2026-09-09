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

  whyDetailedHeading: { en: "Why Plan Your Trip With RideLine", hi: "RideLine के साथ अपनी यात्रा की योजना क्यों बनाएं", or: "RideLine ସହିତ ଆପଣଙ୍କ ଯାତ୍ରା ଯୋଜନା କାହିଁକି କରିବେ" },
  why1Title: { en: "Local Knowledge, Real Recommendations", hi: "स्थानीय जानकारी, असली सलाह", or: "ସ୍ଥାନୀୟ ଜ୍ଞାନ, ପ୍ରକୃତ ପରାମର୍ଶ" },
  why1Body: {
    en: "We're based in Bhubaneswar ourselves — every tour, package, and route comes from people who've actually been there, not a script.",
    hi: "हम खुद भुवनेश्वर में स्थित हैं — हर टूर, पैकेज और रूट उन लोगों से आता है जो वहां वाकई जा चुके हैं, किसी स्क्रिप्ट से नहीं।",
    or: "ଆମେ ନିଜେ ଭୁବନେଶ୍ୱରରେ ଅବସ୍ଥିତ — ପ୍ରତ୍ୟେକ ଟୁର୍, ପ୍ୟାକେଜ୍ ଏବଂ ରୁଟ୍ ପ୍ରକୃତରେ ସେଠାରେ ଯାଇଥିବା ଲୋକଙ୍କଠାରୁ ଆସେ, କୌଣସି ସ୍କ୍ରିପ୍ଟରୁ ନୁହେଁ।",
  },
  why2Title: { en: "Time Saved, Stress Skipped", hi: "समय बचे, तनाव न हो", or: "ସମୟ ସାଶ୍ରୟ, ଚିନ୍ତାମୁକ୍ତ" },
  why2Body: {
    en: "From temple timings to which beach gets crowded by noon, we've done the research so you don't have to.",
    hi: "मंदिर के समय से लेकर दोपहर तक कौन सा समुद्र तट भीड़भाड़ वाला हो जाता है, हमने यह जानकारी पहले ही जुटा ली है ताकि आपको न करनी पड़े।",
    or: "ମନ୍ଦିର ସମୟଠାରୁ ଆରମ୍ଭ କରି ମଧ୍ୟାହ୍ନ ସୁଦ୍ଧା କେଉଁ ବେଳାଭୂମି ଭିଡ଼ ହୋଇଯାଏ, ଆମେ ଏହି ଅନୁସନ୍ଧାନ ପୂର୍ବରୁ କରିସାରିଛୁ ଯାହା ଫଳରେ ଆପଣଙ୍କୁ କରିବାକୁ ପଡ଼ିବ ନାହିଁ।",
  },
  why3Title: { en: "Transparent Pricing", hi: "पारदर्शी कीमत", or: "ସ୍ୱଚ୍ଛ ମୂଲ୍ୟ" },
  why3Body: {
    en: "The price you see is the price you pay — no hidden charges added at checkout, no surprise convenience fees.",
    hi: "जो कीमत आप देखते हैं वही आप चुकाते हैं — चेकआउट पर कोई छिपा शुल्क नहीं, कोई अचानक सुविधा शुल्क नहीं।",
    or: "ଆପଣ ଯେଉଁ ମୂଲ୍ୟ ଦେଖନ୍ତି ତାହା ହିଁ ଆପଣ ଦିଅନ୍ତି — ଚେକଆଉଟ୍ ରେ କୌଣସି ଲୁକ୍କାୟିତ ଚାର୍ଜ ନାହିଁ, କୌଣସି ହଠାତ୍ ସୁବିଧା ଶୁଳ୍କ ନାହିଁ।",
  },
  why4Title: { en: "Flexible By Design", hi: "लचीलापन, हमारी डिज़ाइन में", or: "ନମନୀୟତା, ଆମର ଡିଜାଇନରେ" },
  why4Body: {
    en: "Book a fixed tour, a full package, or just a car and driver to roam as you please — whatever fits how you actually want to travel.",
    hi: "एक तय टूर बुक करें, पूरा पैकेज लें, या बस एक कार और ड्राइवर लेकर अपनी मर्ज़ी से घूमें — जो भी आपके यात्रा करने के तरीके के अनुकूल हो।",
    or: "ଏକ ନିର୍ଦ୍ଧାରିତ ଟୁର୍ ବୁକ୍ କରନ୍ତୁ, ପୂର୍ଣ୍ଣ ପ୍ୟାକେଜ୍ ନିଅନ୍ତୁ, କିମ୍ବା କେବଳ ଏକ କାର୍ ଏବଂ ଡ୍ରାଇଭର ନେଇ ନିଜ ମର୍ଜିରେ ବୁଲନ୍ତୁ — ଯାହା ମଧ୍ୟ ଆପଣ ପ୍ରକୃତରେ ଯାତ୍ରା କରିବାକୁ ଚାହାଁନ୍ତି ତାହା ସହିତ ମେଳ ଖାଏ।",
  },
  why5Title: { en: "Built for Groups Too", hi: "समूहों के लिए भी उपयुक्त", or: "ଗ୍ରୁପ୍ ପାଇଁ ମଧ୍ୟ ଉପଯୁକ୍ତ" },
  why5Body: {
    en: "Planning for a family, a friend circle, or a corporate offsite? We handle group logistics without the usual back-and-forth.",
    hi: "परिवार, दोस्तों के समूह, या कॉर्पोरेट ऑफसाइट की योजना बना रहे हैं? हम सामान्य आगे-पीछे की बातचीत के बिना समूह की व्यवस्था संभालते हैं।",
    or: "ପରିବାର, ବନ୍ଧୁ ଗ୍ରୁପ୍, କିମ୍ବା କର୍ପୋରେଟ୍ ଅଫସାଇଟ୍ ଯୋଜନା କରୁଛନ୍ତି? ଆମେ ସାଧାରଣ ଆଗପଛ ବାର୍ତ୍ତାଳାପ ବିନା ଗ୍ରୁପ୍ ବ୍ୟବସ୍ଥା ସମ୍ଭାଳୁ।",
  },
  why6Title: { en: "Always Reachable", hi: "हमेशा उपलब्ध", or: "ସର୍ବଦା ଉପଲବ୍ଧ" },
  why6Body: {
    en: "Every booking confirms straight to WhatsApp, and a real person answers when you have questions — not a chatbot loop.",
    hi: "हर बुकिंग सीधे WhatsApp पर पक्की होती है, और जब आपके सवाल हों तो एक असली इंसान जवाब देता है — कोई चैटबॉट लूप नहीं।",
    or: "ପ୍ରତ୍ୟେକ ବୁକିଂ ସିଧାସଳଖ WhatsApp ରେ ନିଶ୍ଚିତ ହୁଏ, ଏବଂ ଆପଣଙ୍କ ପ୍ରଶ୍ନ ଥିଲେ ଜଣେ ପ୍ରକୃତ ବ୍ୟକ୍ତି ଉତ୍ତର ଦିଅନ୍ତି — କୌଣସି ଚାଟବଟ୍ ଲୁପ୍ ନୁହେଁ।",
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

