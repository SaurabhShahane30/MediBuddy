import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES =[
  MapLocale('en', LocaleData.EN),
  MapLocale('hi', LocaleData.HI),
  MapLocale('mr', LocaleData.MR),
];
mixin LocaleData {
  static const String welcomeBack = 'welcomeBack';
  static const String welcomeBackText = "welcomeBackText";
  static const String helloText = "helloText";
  static const String donthaveaccount = "donthaveaccount";
  static const String signupnow = "signupnow";
  //static const String medfor = "medfor";
  static const String nomed = 'nomed';
  static const String totake = 'totake' ;
  static const String missed = 'missed';
  static const String taken = 'taken';
  static const String remind = 'remind';
  static const String remindin5 = 'remindin5';
  static const String addnewmed = 'addnewmed';
  static const String medname = 'medname';
  static const String entername = 'entername';
  static const String selecttype = 'selecttype';
  static const String dosage = 'dosage';
  static const String dosageex = 'dosageex';
  static const String whentotake = 'whentotake';
  static const String totaltablets = 'totaltablets';
  static const String outofstock = 'outofstock';
  static const String duration = 'duration';
  static const String to = 'to';
  static const String remindertime = 'remindertime';
  static const String medication_successfully_added = 'medication_successfully_added';
  static const String savemedication = 'save medication';
  static const String createaccount = 'createaccount';
  static const String signup = 'signup';
  static const String locatepharmacy = 'locatepharmacy';
  static const String findnearbypharmacy = 'findnearbypharmacy';
  static const String failed_medication = 'failed_medication';

  static const Map<String, dynamic> EN = {
    welcomeBack :'Welcome Back',
    welcomeBackText:'Login to Continue',
    helloText: 'Hello',
    donthaveaccount: 'Don’t have an account?',
    signupnow: 'Sign up now',
    //medfor: 'Medicines for'
    nomed: 'No medicines scheduled.',
    totake: 'Its time to take',
    missed: 'missed',
    taken: 'taken',
    remind: 'remind',
    remindin5: 'Remind in 5 mins',
    addnewmed: 'add new medicine',
    medname: 'medicine name',
    entername: 'enter name',
    selecttype: 'select type of medicine',
    dosage: 'dosage',
    dosageex: 'Dosage (e.g. 500mg, 1 Spoon)',
    whentotake: 'when to take?',
    totaltablets: 'total tablets?',
    outofstock: '⚠ Out of Stock!',
    duration:'duration',
    to: 'to',
    remindertime: 'reminder time',
    medication_successfully_added: 'medication added successfully!',
    savemedication: 'save medication',
    createaccount: 'create an account',
    signup: 'SIGN UP',
    locatepharmacy: 'locate pharmacy',
    findnearbypharmacy: 'find near by pharmacy',
    failed_medication:'add medication failed',

  };

  static const Map<String, dynamic> HI = {
    welcomeBack :'फिर से स्वागत है',
    welcomeBackText:'जारी रखने के लिए लॉगिन करें',
    helloText: 'नमस्ते',
    donthaveaccount:'खाता नहीं है?',
    signupnow: 'अभी साइन अप करें',
    //medfor:'दवाइयाँ'
    nomed: 'कोई दवाइयाँ निर्धारित नहीं हैं।',
    totake: 'दवा लेने का समय आ गया है;',
    missed: 'छूट गया',
    taken: 'लिया गया',
    remind: 'याद दिलाना',
    remindin5: '5 मिनट में याद दिलाएं',
    addnewmed: 'नई दवा जोड़ें',
    medname : 'दवा का नाम',
    entername: 'नाम दर्ज करें',
    selecttype:'दवा का प्रकार चुनें',
    dosage: 'डोस',
    dosageex: 'डोस (e.g. 500mg, 1 Spoon)',
    whentotake: 'कब लेना है',
    totaltablets: 'कुल गोलियां',
    outofstock: 'स्टॉक खत्म',
    duration:'अवधि',
    to: 'तक',
    remindertime: 'रिमाइंडर समय',
    medication_successfully_added: 'दवा सफलतापूर्वक जोड़ी गई!',
    savemedication:' दवा सुरक्षित करें',
    createaccount: 'खाता बनाएँ',
    signup: 'साइन अप करें',
    locatepharmacy: 'फार्मेसी खोजें',
    findnearbypharmacy: 'पास की फार्मेसी खोजें',
    failed_medication:'दवा जोड़ना असफल रहा',



  };

  static const Map<String, dynamic> MR = {
    welcomeBack :'परत स्वागत आहे',
    welcomeBackText:'सुरू ठेवण्यासाठी लॉगिन करा',
    helloText: 'नमस्कार',
    donthaveaccount: 'खाते नाही का?',
    signupnow: 'आत्ताच साइन अप करा',
    //medfor: 'औषधे',
    nomed: 'कोणतीही औषधे निर्धारित नाहीत',
    totake: 'औषध घेण्याची वेळ झाली आहे',
    missed: 'चुकले',
    taken: 'घेतले',
    remind: 'आठवण करा',
    remindin5: '5 मिनिटांत आठवण करा',
    addnewmed:'नवीन औषध जोडा',
    medname: 'औषधाचे नाव',
    entername: 'नाव प्रविष्ट करा',
    selecttype: 'औषधाचा प्रकार निवडा',
    dosage: 'डोस',
    dosageex: 'डोस (e.g. 500mg, 1 Spoon)',
    whentotake: 'कधी घ्यायचे',
    totaltablets: 'एकूण गोळ्या',
    outofstock: 'साठा संपला',
    duration:'कालावधी',
    to: 'पर्यंत',
    remindertime: 'स्मरण वेळ',
    medication_successfully_added : 'औषध यशस्वीपणे जोडले गेले!',
    savemedication: 'औषध सेव्ह करा',
    createaccount:'खाते तयार करा',
    signup: 'साइन अप करा',
    locatepharmacy: 'फार्मसी शोधा',
    findnearbypharmacy: 'जवळची फार्मसी शोधा',
    failed_medication:'औषध जोडणे अयशस्वी झाले',


  };
}