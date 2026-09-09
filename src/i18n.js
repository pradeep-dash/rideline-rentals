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

