import Func "mo:base/Func";

import Text "mo:base/Text";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";

actor {
  // Define a type for storing translations
  type Translation = {
    original: Text;
    translated: Text;
    language: Text;
  };

  // Create a stable variable to store translations
  stable var translationsEntries : [(Text, Translation)] = [];
  var translations = HashMap.HashMap<Text, Translation>(10, Text.equal, Text.hash);

  // Function to add a translation to the history
  public func addTranslation(original: Text, translated: Text, language: Text) : async () {
    let key = original # language;
    let translation : Translation = {
      original = original;
      translated = translated;
      language = language;
    };
    translations.put(key, translation);
  };

  // Function to get translation history
  public query func getTranslationHistory() : async [Translation] {
    Iter.toArray(translations.vals())
  };

  // System functions for upgrades
  system func preupgrade() {
    translationsEntries := Iter.toArray(translations.entries());
  };

  system func postupgrade() {
    translations := HashMap.fromIter<Text, Translation>(translationsEntries.vals(), 10, Text.equal, Text.hash);
  };
}
