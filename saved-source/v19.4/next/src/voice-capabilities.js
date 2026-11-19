export function getVoiceCapabilities() {
  return {
    speechRecognition: typeof window !== 'undefined' &&
      Boolean(window.SpeechRecognition || window.webkitSpeechRecognition),
    speechSynthesis: typeof window !== 'undefined' &&
      Boolean(window.speechSynthesis),
  };
}

export function createSpeechRecognition(language = 'bn-BD') {
  if (typeof window === 'undefined') return null;
  const Recognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!Recognition) return null;
  const recognition = new Recognition();
  recognition.lang = language;
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;
  return recognition;
}

export function speakText(text, language = 'bn-BD') {
  if (typeof window === 'undefined' || !window.speechSynthesis) {
    throw new Error('এই ডিভাইসে speech synthesis সমর্থিত নয়');
  }
  const utterance = new SpeechSynthesisUtterance(String(text).slice(0, 3000));
  utterance.lang = language;
  window.speechSynthesis.cancel();
  window.speechSynthesis.speak(utterance);
}
