library emoji_picker;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';

enum Category {
  RECOMMENDED,
  SMILEYS,
  ANIMALS,
  FOODS,
  TRAVEL,
  ACTIVITIES,
  OBJECTS,
  SYMBOLS,
  FLAGS
}

enum ButtonMode {
  MATERIAL,
  CUPERTINO
}

typedef void OnEmojiSelected(Emoji emoji, Category category);

class EmojiPicker extends StatefulWidget {

  @override
  _EmojiPickerState createState() => new _EmojiPickerState();

  final int columns;
  final int rows;

  Category selectedCategory;

  final OnEmojiSelected onEmojiSelected;

  Color bgColor;
  Color indicatorColor;

  final Color _defaultBgColor = Color.fromRGBO(242, 242, 242, 1);

  final List<String> recommendKeywords;
  final int numRecommended;

  final String noRecommendationsText;
  TextStyle noRecommendationsStyle;

  CategoryIcons categoryIcons;

  final ButtonMode buttonMode;


  EmojiPicker({
    Key key,
    @required this.onEmojiSelected,
    this.columns = 7,
    this.rows = 3,
    this.selectedCategory,
    this.bgColor,
    this.indicatorColor = Colors.blue,
    this.recommendKeywords,
    this.numRecommended = 10,
    this.noRecommendationsText = "No Recommendations",
    this.noRecommendationsStyle,
    this.categoryIcons,
    this.buttonMode = ButtonMode.MATERIAL
  }) : super(key: key) {

    if (selectedCategory == null) {
      selectedCategory = Category.SMILEYS;
    }

    if (this.noRecommendationsStyle == null) {
      noRecommendationsStyle = TextStyle(fontSize: 20, color: Colors.black26);
    }

    if (this.bgColor == null) {
      bgColor = _defaultBgColor;
    }

    if (categoryIcons == null) {
      categoryIcons = CategoryIcons();
    }

  }

  final Map<String, String> _smileys = new Map.fromIterables(
      ['Grinning Face', 'Grinning Face With Big Eyes', 'Grinning Face With Smiling Eyes', 'Beaming Face With Smiling Eyes', 'Grinning Squinting Face', 'Grinning Face With Sweat', 'Rolling on the Floor Laughing', 'Face With Tears of Joy', 'Slightly Smiling Face', 'Upside-Down Face', 'Winking Face', 'Smiling Face With Smiling Eyes', 'Smiling Face With Halo', 'Smiling Face With Hearts', 'Smiling Face With Heart-Eyes', 'Star-Struck', 'Face Blowing a Kiss', 'Kissing Face', 'Smiling Face', 'Kissing Face With Closed Eyes', 'Kissing Face With Smiling Eyes', 'Face Savoring Food', 'Face With Tongue', 'Winking Face With Tongue', 'Zany Face', 'Squinting Face With Tongue', 'Money-Mouth Face', 'Hugging Face', 'Face With Hand Over Mouth', 'Shushing Face', 'Thinking Face', 'Zipper-Mouth Face', 'Face With Raised Eyebrow', 'Neutral Face', 'Expressionless Face', 'Face Without Mouth', 'Smirking Face', 'Unamused Face', 'Face With Rolling Eyes', 'Grimacing Face', 'Lying Face', 'Relieved Face', 'Pensive Face', 'Sleepy Face', 'Drooling Face', 'Sleeping Face', 'Face With Medical Mask', 'Face With Thermometer', 'Face With Head-Bandage', 'Nauseated Face', 'Face Vomiting', 'Sneezing Face', 'Hot Face', 'Cold Face', 'Woozy Face', 'Dizzy Face', 'Exploding Head', 'Cowboy Hat Face', 'Partying Face', 'Smiling Face With Sunglasses', 'Nerd Face', 'Face With Monocle', 'Confused Face', 'Worried Face', 'Slightly Frowning Face', 'Frowning Face', 'Face With Open Mouth', 'Hushed Face', 'Astonished Face', 'Flushed Face', 'Pleading Face', 'Frowning Face With Open Mouth', 'Anguished Face', 'Fearful Face', 'Anxious Face With Sweat', 'Sad but Relieved Face', 'Crying Face', 'Loudly Crying Face', 'Face Screaming in Fear', 'Confounded Face', 'Persevering Face', 'Disappointed Face', 'Downcast Face With Sweat', 'Weary Face', 'Tired Face', 'Face With Steam From Nose', 'Pouting Face', 'Angry Face', 'Face With Symbols on Mouth', 'Smiling Face With Horns', 'Angry Face With Horns', 'Skull', 'Skull and Crossbones', 'Pile of Poo', 'Clown Face', 'Ogre', 'Goblin', 'Ghost', 'Alien', 'Alien Monster', 'Robot Face', 'Grinning Cat Face', 'Grinning Cat Face With Smiling Eyes', 'Cat Face With Tears of Joy', 'Smiling Cat Face With Heart-Eyes', 'Cat Face With Wry Smile', 'Kissing Cat Face', 'Weary Cat Face', 'Crying Cat Face', 'Pouting Cat Face', 'Kiss Mark', 'Waving Hand', 'Raised Back of Hand', 'Hand With Fingers Splayed', 'Raised Hand', 'Vulcan Salute', 'OK Hand', 'Victory Hand', 'Crossed Fingers', 'Love-You Gesture', 'Sign of the Horns', 'Call Me Hand', 'Backhand Index Pointing Left', 'Backhand Index Pointing Right', 'Backhand Index Pointing Up', 'Middle Finger', 'Backhand Index Pointing Down', 'Index Pointing Up', 'Thumbs Up', 'Thumbs Down', 'Raised Fist', 'Oncoming Fist', 'Left-Facing Fist', 'Right-Facing Fist', 'Clapping Hands', 'Raising Hands', 'Open Hands', 'Palms Up Together', 'Handshake', 'Folded Hands', 'Writing Hand', 'Nail Polish', 'Selfie', 'Flexed Biceps', 'Leg', 'Foot', 'Ear', 'Nose', 'Brain', 'Tooth', 'Bone', 'Eyes', 'Eye', 'Tongue', 'Mouth', 'Baby', 'Child', 'Boy', 'Girl', 'Person', 'Man', 'Man: Beard', 'Man: Blond Hair', 'Man: Red Hair', 'Man: Curly Hair', 'Man: White Hair', 'Man: Bald', 'Woman', 'Woman: Blond Hair', 'Woman: Red Hair', 'Woman: Curly Hair', 'Woman: White Hair', 'Woman: Bald', 'Older Person', 'Old Man', 'Old Woman', 'Man Frowning', 'Woman Frowning', 'Man Pouting', 'Woman Pouting', 'Man Gesturing No', 'Woman Gesturing No', 'Man Gesturing OK', 'Woman Gesturing OK', 'Man Tipping Hand', 'Woman Tipping Hand', 'Man Raising Hand', 'Woman Raising Hand', 'Man Bowing', 'Woman Bowing', 'Man Facepalming', 'Woman Facepalming', 'Man Shrugging', 'Woman Shrugging', 'Man Health Worker', 'Woman Health Worker', 'Man Student', 'Woman Student', 'Man Teacher', 'Woman Teacher', 'Man Judge', 'Woman Judge', 'Man Farmer', 'Woman Farmer', 'Man Cook', 'Woman Cook', 'Man Mechanic', 'Woman Mechanic', 'Man Factory Worker', 'Woman Factory Worker', 'Man Office Worker', 'Woman Office Worker', 'Man Scientist', 'Woman Scientist', 'Man Technologist', 'Woman Technologist', 'Man Singer', 'Woman Singer', 'Man Artist', 'Woman Artist', 'Man Pilot', 'Woman Pilot', 'Man Astronaut', 'Woman Astronaut', 'Man Firefighter', 'Woman Firefighter', 'Man Police Officer', 'Woman Police Officer', 'Man Detective', 'Woman Detective', 'Man Guard', 'Woman Guard', 'Man Construction Worker', 'Woman Construction Worker', 'Prince', 'Princess', 'Man Wearing Turban', 'Woman Wearing Turban', 'Man With Chinese Cap', 'Woman With Headscarf', 'Man in Tuxedo', 'Bride With Veil', 'Pregnant Woman', 'Breast-Feeding', 'Baby Angel', 'Santa Claus', 'Mrs. Claus', 'Man Superhero', 'Woman Superhero', 'Man Supervillain', 'Woman Supervillain', 'Man Mage', 'Woman Mage', 'Man Fairy', 'Woman Fairy', 'Man Vampire', 'Woman Vampire', 'Merman', 'Mermaid', 'Man Elf', 'Woman Elf', 'Man Genie', 'Woman Genie', 'Man Zombie', 'Woman Zombie', 'Man Getting Massage', 'Woman Getting Massage', 'Man Getting Haircut', 'Woman Getting Haircut', 'Man Walking', 'Woman Walking', 'Man Running', 'Woman Running', 'Woman Dancing', 'Man Dancing', 'Man in Suit Levitating', 'Men With Bunny Ears', 'Women With Bunny Ears', 'Man in Steamy Room', 'Woman in Steamy Room', 'Person in Lotus Position', 'Women Holding Hands', 'Woman and Man Holding Hands', 'Men Holding Hands', 'Kiss', 'Kiss: Man, Man', 'Kiss: Woman, Woman', 'Couple With Heart', 'Couple With Heart: Man, Man', 'Couple With Heart: Woman, Woman', 'Family', 'Family: Man, Woman, Boy', 'Family: Man, Woman, Girl', 'Family: Man, Woman, Girl, Boy', 'Family: Man, Woman, Boy, Boy', 'Family: Man, Woman, Girl, Girl', 'Family: Man, Man, Boy', 'Family: Man, Man, Girl', 'Family: Man, Man, Girl, Boy', 'Family: Man, Man, Boy, Boy', 'Family: Man, Man, Girl, Girl', 'Family: Woman, Woman, Boy', 'Family: Woman, Woman, Girl', 'Family: Woman, Woman, Girl, Boy', 'Family: Woman, Woman, Boy, Boy', 'Family: Woman, Woman, Girl, Girl', 'Family: Man, Boy', 'Family: Man, Boy, Boy', 'Family: Man, Girl', 'Family: Man, Girl, Boy', 'Family: Man, Girl, Girl', 'Family: Woman, Boy', 'Family: Woman, Boy, Boy', 'Family: Woman, Girl', 'Family: Woman, Girl, Boy', 'Family: Woman, Girl, Girl', 'Speaking Head', 'Bust in Silhouette', 'Busts in Silhouette', 'Footprints', 'Luggage', 'Closed Umbrella', 'Umbrella', 'Thread', 'Yarn', 'Glasses', 'Sunglasses', 'Goggles', 'Lab Coat', 'Necktie', 'T-Shirt', 'Jeans', 'Scarf', 'Gloves', 'Coat', 'Socks', 'Dress', 'Kimono', 'Bikini', 'Woman’s Clothes', 'Purse', 'Handbag', 'Clutch Bag', 'Backpack', 'Man’s Shoe', 'Running Shoe', 'Hiking Boot', 'Flat Shoe', 'High-Heeled Shoe', 'Woman’s Sandal', 'Woman’s Boot', 'Crown', 'Woman’s Hat', 'Top Hat', 'Graduation Cap', 'Billed Cap', 'Rescue Worker’s Helmet', 'Lipstick', 'Ring', 'Briefcase'],
      ['😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃', '😉', '😊', '😇', '🥰', '😍', '🤩', '😘', '😗', '☺', '😚', '😙', '😋', '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '🤐', '🤨', '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤥', '😌', '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢', '🤮', '🤧', '🥵', '🥶', '🥴', '😵', '🤯', '🤠', '🥳', '😎', '🤓', '🧐', '😕', '😟', '🙁', '☹', '😮', '😯', '😲', '😳', '🥺', '😦', '😧', '😨', '😰', '😥', '😢', '😭', '😱', '😖', '😣', '😞', '😓', '😩', '😫', '😤', '😡', '😠', '🤬', '😈', '👿', '💀', '☠', '💩', '🤡', '👹', '👺', '👻', '👽', '👾', '🤖', '😺', '😸', '😹', '😻', '😼', '😽', '🙀', '😿', '😾', '💋', '👋', '🤚', '🖐', '✋', '🖖', '👌', '✌', '🤞', '🤟', '🤘', '🤙', '👈', '👉', '👆', '🖕', '👇', '☝', '👍', '👎', '✊', '👊', '🤛', '🤜', '👏', '🙌', '👐', '🤲', '🤝', '🙏', '✍', '💅', '🤳', '💪', '🦵', '🦶', '👂', '👃', '🧠', '🦷', '🦴', '👀', '👁', '👅', '👄', '👶', '🧒', '👦', '👧', '🧑', '👨', '🧔', '👱\u200d♂️', '👨\u200d🦰', '👨\u200d🦱', '👨\u200d🦳', '👨\u200d🦲', '👩', '👱\u200d♀️', '👩\u200d🦰', '👩\u200d🦱', '👩\u200d🦳', '👩\u200d🦲', '🧓', '👴', '👵', '🙍\u200d♂️', '🙍\u200d♀️', '🙎\u200d♂️', '🙎\u200d♀️', '🙅\u200d♂️', '🙅\u200d♀️', '🙆\u200d♂️', '🙆\u200d♀️', '💁\u200d♂️', '💁\u200d♀️', '🙋\u200d♂️', '🙋\u200d♀️', '🙇\u200d♂️', '🙇\u200d♀️', '🤦\u200d♂️', '🤦\u200d♀️', '🤷\u200d♂️', '🤷\u200d♀️', '👨\u200d⚕️', '👩\u200d⚕️', '👨\u200d🎓', '👩\u200d🎓', '👨\u200d🏫', '👩\u200d🏫', '👨\u200d⚖️', '👩\u200d⚖️', '👨\u200d🌾', '👩\u200d🌾', '👨\u200d🍳', '👩\u200d🍳', '👨\u200d🔧', '👩\u200d🔧', '👨\u200d🏭', '👩\u200d🏭', '👨\u200d💼', '👩\u200d💼', '👨\u200d🔬', '👩\u200d🔬', '👨\u200d💻', '👩\u200d💻', '👨\u200d🎤', '👩\u200d🎤', '👨\u200d🎨', '👩\u200d🎨', '👨\u200d✈️', '👩\u200d✈️', '👨\u200d🚀', '👩\u200d🚀', '👨\u200d🚒', '👩\u200d🚒', '👮\u200d♂️', '👮\u200d♀️', '🕵️\u200d♂️', '🕵️\u200d♀️', '💂\u200d♂️', '💂\u200d♀️', '👷\u200d♂️', '👷\u200d♀️', '🤴', '👸', '👳\u200d♂️', '👳\u200d♀️', '👲', '🧕', '🤵', '👰', '🤰', '🤱', '👼', '🎅', '🤶', '🦸\u200d♂️', '🦸\u200d♀️', '🦹\u200d♂️', '🦹\u200d♀️', '🧙\u200d♂️', '🧙\u200d♀️', '🧚\u200d♂️', '🧚\u200d♀️', '🧛\u200d♂️', '🧛\u200d♀️', '🧜\u200d♂️', '🧜\u200d♀️', '🧝\u200d♂️', '🧝\u200d♀️', '🧞\u200d♂️', '🧞\u200d♀️', '🧟\u200d♂️', '🧟\u200d♀️', '💆\u200d♂️', '💆\u200d♀️', '💇\u200d♂️', '💇\u200d♀️', '🚶\u200d♂️', '🚶\u200d♀️', '🏃\u200d♂️', '🏃\u200d♀️', '💃', '🕺', '🕴', '👯\u200d♂️', '👯\u200d♀️', '🧖\u200d♂️', '🧖\u200d♀️', '🧘', '👭', '👫', '👬', '💏', '👨\u200d❤️\u200d💋\u200d👨', '👩\u200d❤️\u200d💋\u200d👩', '💑', '👨\u200d❤️\u200d👨', '👩\u200d❤️\u200d👩', '👪', '👨\u200d👩\u200d👦', '👨\u200d👩\u200d👧', '👨\u200d👩\u200d👧\u200d👦', '👨\u200d👩\u200d👦\u200d👦', '👨\u200d👩\u200d👧\u200d👧', '👨\u200d👨\u200d👦', '👨\u200d👨\u200d👧', '👨\u200d👨\u200d👧\u200d👦', '👨\u200d👨\u200d👦\u200d👦', '👨\u200d👨\u200d👧\u200d👧', '👩\u200d👩\u200d👦', '👩\u200d👩\u200d👧', '👩\u200d👩\u200d👧\u200d👦', '👩\u200d👩\u200d👦\u200d👦', '👩\u200d👩\u200d👧\u200d👧', '👨\u200d👦', '👨\u200d👦\u200d👦', '👨\u200d👧', '👨\u200d👧\u200d👦', '👨\u200d👧\u200d👧', '👩\u200d👦', '👩\u200d👦\u200d👦', '👩\u200d👧', '👩\u200d👧\u200d👦', '👩\u200d👧\u200d👧', '🗣', '👤', '👥', '👣', '🧳', '🌂', '☂', '🧵', '🧶', '👓', '🕶', '🥽', '🥼', '👔', '👕', '👖', '🧣', '🧤', '🧥', '🧦', '👗', '👘', '👙', '👚', '👛', '👜', '👝', '🎒', '👞', '👟', '🥾', '🥿', '👠', '👡', '👢', '👑', '👒', '🎩', '🎓', '🧢', '⛑', '💄', '💍', '💼']
  );

  final Map<String ,String> _animals = new Map.fromIterables(
      ['See-No-Evil Monkey', 'Hear-No-Evil Monkey', 'Speak-No-Evil Monkey', 'Collision', 'Dizzy', 'Sweat Droplets', 'Dashing Away', 'Monkey Face', 'Monkey', 'Gorilla', 'Dog Face', 'Dog', 'Poodle', 'Wolf Face', 'Fox Face', 'Raccoon', 'Cat Face', 'Cat', 'Lion Face', 'Tiger Face', 'Tiger', 'Leopard', 'Horse Face', 'Horse', 'Unicorn Face', 'Zebra', 'Cow Face', 'Ox', 'Water Buffalo', 'Cow', 'Pig Face', 'Pig', 'Boar', 'Pig Nose', 'Ram', 'Ewe', 'Goat', 'Camel', 'Two-Hump Camel', 'Llama', 'Giraffe', 'Elephant', 'Rhinoceros', 'Hippopotamus', 'Mouse Face', 'Mouse', 'Rat', 'Hamster Face', 'Rabbit Face', 'Rabbit', 'Chipmunk', 'Hedgehog', 'Bat', 'Bear Face', 'Koala', 'Panda Face', 'Kangaroo', 'Badger', 'Paw Prints', 'Turkey', 'Chicken', 'Rooster', 'Hatching Chick', 'Baby Chick', 'Front-Facing Baby Chick', 'Bird', 'Penguin', 'Dove', 'Eagle', 'Duck', 'Swan', 'Owl', 'Peacock', 'Parrot', 'Frog Face', 'Crocodile', 'Turtle', 'Lizard', 'Snake', 'Dragon Face', 'Dragon', 'Sauropod', 'T-Rex', 'Spouting Whale', 'Whale', 'Dolphin', 'Fish', 'Tropical Fish', 'Blowfish', 'Shark', 'Octopus', 'Spiral Shell', 'Snail', 'Butterfly', 'Bug', 'Ant', 'Honeybee', 'Lady Beetle', 'Cricket', 'Spider', 'Spider Web', 'Scorpion', 'Mosquito', 'Microbe', 'Bouquet', 'Cherry Blossom', 'White Flower', 'Rosette', 'Rose', 'Wilted Flower', 'Hibiscus', 'Sunflower', 'Blossom', 'Tulip', 'Seedling', 'Evergreen Tree', 'Deciduous Tree', 'Palm Tree', 'Cactus', 'Sheaf of Rice', 'Herb', 'Shamrock', 'Four Leaf Clover', 'Maple Leaf', 'Fallen Leaf', 'Leaf Fluttering in Wind', 'Mushroom', 'Chestnut', 'Crab', 'Lobster', 'Shrimp', 'Squid', 'Globe Showing Europe-Africa', 'Globe Showing Americas', 'Globe Showing Asia-Australia', 'Globe With Meridians', 'New Moon', 'Waxing Crescent Moon', 'First Quarter Moon', 'Waxing Gibbous Moon', 'Full Moon', 'Waning Gibbous Moon', 'Last Quarter Moon', 'Waning Crescent Moon', 'Crescent Moon', 'New Moon Face', 'First Quarter Moon Face', 'Last Quarter Moon Face', 'Sun', 'Full Moon Face', 'Sun With Face', 'Star', 'Glowing Star', 'Shooting Star', 'Cloud', 'Sun Behind Cloud', 'Cloud With Lightning and Rain', 'Sun Behind Small Cloud', 'Sun Behind Large Cloud', 'Sun Behind Rain Cloud', 'Cloud With Rain', 'Cloud With Snow', 'Cloud With Lightning', 'Tornado', 'Fog', 'Wind Face', 'Rainbow', 'Umbrella', 'Umbrella With Rain Drops', 'High Voltage', 'Snowflake', 'Snowman', 'Snowman Without Snow', 'Comet', 'Fire', 'Droplet', 'Water Wave', 'Christmas Tree', 'Sparkles', 'Tanabata Tree', 'Pine Decoration'],
      ['🙈', '🙉', '🙊', '💥', '💫', '💦', '💨', '🐵', '🐒', '🦍', '🐶', '🐕', '🐩', '🐺', '🦊', '🦝', '🐱', '🐈', '🦁', '🐯', '🐅', '🐆', '🐴', '🐎', '🦄', '🦓', '🐮', '🐂', '🐃', '🐄', '🐷', '🐖', '🐗', '🐽', '🐏', '🐑', '🐐', '🐪', '🐫', '🦙', '🦒', '🐘', '🦏', '🦛', '🐭', '🐁', '🐀', '🐹', '🐰', '🐇', '🐿', '🦔', '🦇', '🐻', '🐨', '🐼', '🦘', '🦡', '🐾', '🦃', '🐔', '🐓', '🐣', '🐤', '🐥', '🐦', '🐧', '🕊', '🦅', '🦆', '🦢', '🦉', '🦚', '🦜', '🐸', '🐊', '🐢', '🦎', '🐍', '🐲', '🐉', '🦕', '🦖', '🐳', '🐋', '🐬', '🐟', '🐠', '🐡', '🦈', '🐙', '🐚', '🐌', '🦋', '🐛', '🐜', '🐝', '🐞', '🦗', '🕷', '🕸', '🦂', '🦟', '🦠', '💐', '🌸', '💮', '🏵', '🌹', '🥀', '🌺', '🌻', '🌼', '🌷', '🌱', '🌲', '🌳', '🌴', '🌵', '🌾', '🌿', '☘', '🍀', '🍁', '🍂', '🍃', '🍄', '🌰', '🦀', '🦞', '🦐', '🦑', '🌍', '🌎', '🌏', '🌐', '🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘', '🌙', '🌚', '🌛', '🌜', '☀', '🌝', '🌞', '⭐', '🌟', '🌠', '☁', '⛅', '⛈', '🌤', '🌥', '🌦', '🌧', '🌨', '🌩', '🌪', '🌫', '🌬', '🌈', '☂', '☔', '⚡', '❄', '☃', '⛄', '☄', '🔥', '💧', '🌊', '🎄', '✨', '🎋', '🎍']
  );

  final Map<String, String> _foods = new Map.fromIterables(
      ['Grapes', 'Melon', 'Watermelon', 'Tangerine', 'Lemon', 'Banana', 'Pineapple', 'Mango', 'Red Apple', 'Green Apple', 'Pear', 'Peach', 'Cherries', 'Strawberry', 'Kiwi Fruit', 'Tomato', 'Coconut', 'Avocado', 'Eggplant', 'Potato', 'Carrot', 'Ear of Corn', 'Hot Pepper', 'Cucumber', 'Leafy Green', 'Broccoli', 'Mushroom', 'Peanuts', 'Chestnut', 'Bread', 'Croissant', 'Baguette Bread', 'Pretzel', 'Bagel', 'Pancakes', 'Cheese Wedge', 'Meat on Bone', 'Poultry Leg', 'Cut of Meat', 'Bacon', 'Hamburger', 'French Fries', 'Pizza', 'Hot Dog', 'Sandwich', 'Taco', 'Burrito', 'Stuffed Flatbread', 'Cooking', 'Shallow Pan of Food', 'Pot of Food', 'Bowl With Spoon', 'Green Salad', 'Popcorn', 'Salt', 'Canned Food', 'Bento Box', 'Rice Cracker', 'Rice Ball', 'Cooked Rice', 'Curry Rice', 'Steaming Bowl', 'Spaghetti', 'Roasted Sweet Potato', 'Oden', 'Sushi', 'Fried Shrimp', 'Fish Cake With Swirl', 'Moon Cake', 'Dango', 'Dumpling', 'Fortune Cookie', 'Takeout Box', 'Soft Ice Cream', 'Shaved Ice', 'Ice Cream', 'Doughnut', 'Cookie', 'Birthday Cake', 'Shortcake', 'Cupcake', 'Pie', 'Chocolate Bar', 'Candy', 'Lollipop', 'Custard', 'Honey Pot', 'Baby Bottle', 'Glass of Milk', 'Hot Beverage', 'Teacup Without Handle', 'Sake', 'Bottle With Popping Cork', 'Wine Glass', 'Cocktail Glass', 'Tropical Drink', 'Beer Mug', 'Clinking Beer Mugs', 'Clinking Glasses', 'Tumbler Glass', 'Cup With Straw', 'Chopsticks', 'Fork and Knife With Plate', 'Fork and Knife', 'Spoon'],
      ['🍇', '🍈', '🍉', '🍊', '🍋', '🍌', '🍍', '🥭', '🍎', '🍏', '🍐', '🍑', '🍒', '🍓', '🥝', '🍅', '🥥', '🥑', '🍆', '🥔', '🥕', '🌽', '🌶', '🥒', '🥬', '🥦', '🍄', '🥜', '🌰', '🍞', '🥐', '🥖', '🥨', '🥯', '🥞', '🧀', '🍖', '🍗', '🥩', '🥓', '🍔', '🍟', '🍕', '🌭', '🥪', '🌮', '🌯', '🥙', '🍳', '🥘', '🍲', '🥣', '🥗', '🍿', '🧂', '🥫', '🍱', '🍘', '🍙', '🍚', '🍛', '🍜', '🍝', '🍠', '🍢', '🍣', '🍤', '🍥', '🥮', '🍡', '🥟', '🥠', '🥡', '🍦', '🍧', '🍨', '🍩', '🍪', '🎂', '🍰', '🧁', '🥧', '🍫', '🍬', '🍭', '🍮', '🍯', '🍼', '🥛', '☕', '🍵', '🍶', '🍾', '🍷', '🍸', '🍹', '🍺', '🍻', '🥂', '🥃', '🥤', '🥢', '🍽', '🍴', '🥄']
  );

  final Map<String, String> _travel = new Map.fromIterables(
      ['Person Rowing Boat', 'Map of Japan', 'Snow-Capped Mountain', 'Mountain', 'Volcano', 'Mount Fuji', 'Camping', 'Beach With Umbrella', 'Desert', 'Desert Island', 'National Park', 'Stadium', 'Classical Building', 'Building Construction', 'Houses', 'Derelict House', 'House', 'House With Garden', 'Office Building', 'Japanese Post Office', 'Post Office', 'Hospital', 'Bank', 'Hotel', 'Love Hotel', 'Convenience Store', 'School', 'Department Store', 'Factory', 'Japanese Castle', 'Castle', 'Wedding', 'Tokyo Tower', 'Statue of Liberty', 'Church', 'Mosque', 'Synagogue', 'Shinto Shrine', 'Kaaba', 'Fountain', 'Tent', 'Foggy', 'Night With Stars', 'Cityscape', 'Sunrise Over Mountains', 'Sunrise', 'Cityscape at Dusk', 'Sunset', 'Bridge at Night', 'Carousel Horse', 'Ferris Wheel', 'Roller Coaster', 'Locomotive', 'Railway Car', 'High-Speed Train', 'Bullet Train', 'Train', 'Metro', 'Light Rail', 'Station', 'Tram', 'Monorail', 'Mountain Railway', 'Tram Car', 'Bus', 'Oncoming Bus', 'Trolleybus', 'Minibus', 'Ambulance', 'Fire Engine', 'Police Car', 'Oncoming Police Car', 'Taxi', 'Oncoming Taxi', 'Automobile', 'Oncoming Automobile', 'Delivery Truck', 'Articulated Lorry', 'Tractor', 'Racing Car', 'Motorcycle', 'Motor Scooter', 'Bicycle', 'Kick Scooter', 'Bus Stop', 'Railway Track', 'Fuel Pump', 'Police Car Light', 'Horizontal Traffic Light', 'Vertical Traffic Light', 'Construction', 'Anchor', 'Sailboat', 'Speedboat', 'Passenger Ship', 'Ferry', 'Motor Boat', 'Ship', 'Airplane', 'Small Airplane', 'Airplane Departure', 'Airplane Arrival', 'Seat', 'Helicopter', 'Suspension Railway', 'Mountain Cableway', 'Aerial Tramway', 'Satellite', 'Rocket', 'Flying Saucer', 'Shooting Star', 'Milky Way', 'Umbrella on Ground', 'Fireworks', 'Sparkler', 'Moon Viewing Ceremony', 'Yen Banknote', 'Dollar Banknote', 'Euro Banknote', 'Pound Banknote', 'Moai', 'Passport Control', 'Customs', 'Baggage Claim', 'Left Luggage'],
      ['🚣', '🗾', '🏔', '⛰', '🌋', '🗻', '🏕', '🏖', '🏜', '🏝', '🏞', '🏟', '🏛', '🏗', '🏘', '🏚', '🏠', '🏡', '🏢', '🏣', '🏤', '🏥', '🏦', '🏨', '🏩', '🏪', '🏫', '🏬', '🏭', '🏯', '🏰', '💒', '🗼', '🗽', '⛪', '🕌', '🕍', '⛩', '🕋', '⛲', '⛺', '🌁', '🌃', '🏙', '🌄', '🌅', '🌆', '🌇', '🌉', '🎠', '🎡', '🎢', '🚂', '🚃', '🚄', '🚅', '🚆', '🚇', '🚈', '🚉', '🚊', '🚝', '🚞', '🚋', '🚌', '🚍', '🚎', '🚐', '🚑', '🚒', '🚓', '🚔', '🚕', '🚖', '🚗', '🚘', '🚚', '🚛', '🚜', '🏎', '🏍', '🛵', '🚲', '🛴', '🚏', '🛤', '⛽', '🚨', '🚥', '🚦', '🚧', '⚓', '⛵', '🚤', '🛳', '⛴', '🛥', '🚢', '✈', '🛩', '🛫', '🛬', '💺', '🚁', '🚟', '🚠', '🚡', '🛰', '🚀', '🛸', '🌠', '🌌', '⛱', '🎆', '🎇', '🎑', '💴', '💵', '💶', '💷', '🗿', '🛂', '🛃', '🛄', '🛅']
  );

  final Map<String, String> _activities = new Map.fromIterables(
      ['Man in Suit Levitating', 'Man Climbing', 'Woman Climbing', 'Horse Racing', 'Skier', 'Snowboarder', 'Man Golfing', 'Woman Golfing', 'Man Surfing', 'Woman Surfing', 'Man Rowing Boat', 'Woman Rowing Boat', 'Man Swimming', 'Woman Swimming', 'Man Bouncing Ball', 'Woman Bouncing Ball', 'Man Lifting Weights', 'Woman Lifting Weights', 'Man Biking', 'Woman Biking', 'Man Mountain Biking', 'Woman Mountain Biking', 'Man Cartwheeling', 'Woman Cartwheeling', 'Men Wrestling', 'Women Wrestling', 'Man Playing Water Polo', 'Woman Playing Water Polo', 'Man Playing Handball', 'Woman Playing Handball', 'Man Juggling', 'Woman Juggling', 'Man in Lotus Position', 'Woman in Lotus Position', 'Circus Tent', 'Skateboard', 'Reminder Ribbon', 'Admission Tickets', 'Ticket', 'Military Medal', 'Trophy', 'Sports Medal', '1st Place Medal', '2nd Place Medal', '3rd Place Medal', 'Soccer Ball', 'Baseball', 'Softball', 'Basketball', 'Volleyball', 'American Football', 'Rugby Football', 'Tennis', 'Flying Disc', 'Bowling', 'Cricket Game', 'Field Hockey', 'Ice Hockey', 'Lacrosse', 'Ping Pong', 'Badminton', 'Boxing Glove', 'Martial Arts Uniform', 'Flag in Hole', 'Ice Skate', 'Fishing Pole', 'Running Shirt', 'Skis', 'Sled', 'Curling Stone', 'Direct Hit', 'Pool 8 Ball', 'Video Game', 'Slot Machine', 'Game Die', 'Jigsaw', 'Chess Pawn', 'Performing Arts', 'Artist Palette', 'Thread', 'Yarn', 'Musical Score', 'Microphone', 'Headphone', 'Saxophone', 'Guitar', 'Musical Keyboard', 'Trumpet', 'Violin', 'Drum', 'Clapper Board', 'Bow and Arrow'],
      ['🕴', '🧗\u200d♂️', '🧗\u200d♀️', '🏇', '⛷', '🏂', '🏌️\u200d♂️', '🏌️\u200d♀️', '🏄\u200d♂️', '🏄\u200d♀️', '🚣\u200d♂️', '🚣\u200d♀️', '🏊\u200d♂️', '🏊\u200d♀️', '⛹️\u200d♂️', '⛹️\u200d♀️', '🏋️\u200d♂️', '🏋️\u200d♀️', '🚴\u200d♂️', '🚴\u200d♀️', '🚵\u200d♂️', '🚵\u200d♀️', '🤸\u200d♂️', '🤸\u200d♀️', '🤼\u200d♂️', '🤼\u200d♀️', '🤽\u200d♂️', '🤽\u200d♀️', '🤾\u200d♂️', '🤾\u200d♀️', '🤹\u200d♂️', '🤹\u200d♀️', '🧘\u200d♂️', '🧘\u200d♀️', '🎪', '🛹', '🎗', '🎟', '🎫', '🎖', '🏆', '🏅', '🥇', '🥈', '🥉', '⚽', '⚾', '🥎', '🏀', '🏐', '🏈', '🏉', '🎾', '🥏', '🎳', '🏏', '🏑', '🏒', '🥍', '🏓', '🏸', '🥊', '🥋', '⛳', '⛸', '🎣', '🎽', '🎿', '🛷', '🥌', '🎯', '🎱', '🎮', '🎰', '🎲', '🧩', '♟', '🎭', '🎨', '🧵', '🧶', '🎼', '🎤', '🎧', '🎷', '🎸', '🎹', '🎺', '🎻', '🥁', '🎬', '🏹']
  );

  final Map<String, String> _objects = new Map.fromIterables(
      ['Love Letter', 'Hole', 'Bomb', 'Person Taking Bath', 'Person in Bed', 'Kitchen Knife', 'Amphora', 'World Map', 'Compass', 'Brick', 'Barber Pole', 'Oil Drum', 'Bellhop Bell', 'Luggage', 'Hourglass Done', 'Hourglass Not Done', 'Watch', 'Alarm Clock', 'Stopwatch', 'Timer Clock', 'Mantelpiece Clock', 'Thermometer', 'Umbrella on Ground', 'Firecracker', 'Balloon', 'Party Popper', 'Confetti Ball', 'Japanese Dolls', 'Carp Streamer', 'Wind Chime', 'Red Envelope', 'Ribbon', 'Wrapped Gift', 'Crystal Ball', 'Nazar Amulet', 'Joystick', 'Teddy Bear', 'Framed Picture', 'Thread', 'Yarn', 'Shopping Bags', 'Prayer Beads', 'Gem Stone', 'Postal Horn', 'Studio Microphone', 'Level Slider', 'Control Knobs', 'Radio', 'Mobile Phone', 'Mobile Phone With Arrow', 'Telephone', 'Telephone Receiver', 'Pager', 'Fax Machine', 'Battery', 'Electric Plug', 'Laptop Computer', 'Desktop Computer', 'Printer', 'Keyboard', 'Computer Mouse', 'Trackball', 'Computer Disk', 'Floppy Disk', 'Optical Disk', 'DVD', 'Abacus', 'Movie Camera', 'Film Frames', 'Film Projector', 'Television', 'Camera', 'Camera With Flash', 'Video Camera', 'Videocassette', 'Magnifying Glass Tilted Left', 'Magnifying Glass Tilted Right', 'Candle', 'Light Bulb', 'Flashlight', 'Red Paper Lantern', 'Notebook With Decorative Cover', 'Closed Book', 'Open Book', 'Green Book', 'Blue Book', 'Orange Book', 'Books', 'Notebook', 'Page With Curl', 'Scroll', 'Page Facing Up', 'Newspaper', 'Rolled-Up Newspaper', 'Bookmark Tabs', 'Bookmark', 'Label', 'Money Bag', 'Yen Banknote', 'Dollar Banknote', 'Euro Banknote', 'Pound Banknote', 'Money With Wings', 'Credit Card', 'Receipt', 'Envelope', 'E-Mail', 'Incoming Envelope', 'Envelope With Arrow', 'Outbox Tray', 'Inbox Tray', 'Package', 'Closed Mailbox With Raised Flag', 'Closed Mailbox With Lowered Flag', 'Open Mailbox With Raised Flag', 'Open Mailbox With Lowered Flag', 'Postbox', 'Ballot Box With Ballot', 'Pencil', 'Black Nib', 'Fountain Pen', 'Pen', 'Paintbrush', 'Crayon', 'Memo', 'File Folder', 'Open File Folder', 'Card Index Dividers', 'Calendar', 'Tear-Off Calendar', 'Spiral Notepad', 'Spiral Calendar', 'Card Index', 'Chart Increasing', 'Chart Decreasing', 'Bar Chart', 'Clipboard', 'Pushpin', 'Round Pushpin', 'Paperclip', 'Linked Paperclips', 'Straight Ruler', 'Triangular Ruler', 'Scissors', 'Card File Box', 'File Cabinet', 'Wastebasket', 'Locked', 'Unlocked', 'Locked With Pen', 'Locked With Key', 'Key', 'Old Key', 'Hammer', 'Pick', 'Hammer and Pick', 'Hammer and Wrench', 'Dagger', 'Crossed Swords', 'Pistol', 'Shield', 'Wrench', 'Nut and Bolt', 'Gear', 'Clamp', 'Balance Scale', 'Link', 'Chains', 'Toolbox', 'Magnet', 'Alembic', 'Test Tube', 'Petri Dish', 'DNA', 'Microscope', 'Telescope', 'Satellite Antenna', 'Syringe', 'Pill', 'Door', 'Bed', 'Couch and Lamp', 'Toilet', 'Shower', 'Bathtub', 'Lotion Bottle', 'Safety Pin', 'Broom', 'Basket', 'Roll of Paper', 'Soap', 'Sponge', 'Fire Extinguisher', 'Cigarette', 'Coffin', 'Funeral Urn', 'Moai', 'Potable Water'],
      ['💌', '🕳', '💣', '🛀', '🛌', '🔪', '🏺', '🗺', '🧭', '🧱', '💈', '🛢', '🛎', '🧳', '⌛', '⏳', '⌚', '⏰', '⏱', '⏲', '🕰', '🌡', '⛱', '🧨', '🎈', '🎉', '🎊', '🎎', '🎏', '🎐', '🧧', '🎀', '🎁', '🔮', '🧿', '🕹', '🧸', '🖼', '🧵', '🧶', '🛍', '📿', '💎', '📯', '🎙', '🎚', '🎛', '📻', '📱', '📲', '☎', '📞', '📟', '📠', '🔋', '🔌', '💻', '🖥', '🖨', '⌨', '🖱', '🖲', '💽', '💾', '💿', '📀', '🧮', '🎥', '🎞', '📽', '📺', '📷', '📸', '📹', '📼', '🔍', '🔎', '🕯', '💡', '🔦', '🏮', '📔', '📕', '📖', '📗', '📘', '📙', '📚', '📓', '📃', '📜', '📄', '📰', '🗞', '📑', '🔖', '🏷', '💰', '💴', '💵', '💶', '💷', '💸', '💳', '🧾', '✉', '📧', '📨', '📩', '📤', '📥', '📦', '📫', '📪', '📬', '📭', '📮', '🗳', '✏', '✒', '🖋', '🖊', '🖌', '🖍', '📝', '📁', '📂', '🗂', '📅', '📆', '🗒', '🗓', '📇', '📈', '📉', '📊', '📋', '📌', '📍', '📎', '🖇', '📏', '📐', '✂', '🗃', '🗄', '🗑', '🔒', '🔓', '🔏', '🔐', '🔑', '🗝', '🔨', '⛏', '⚒', '🛠', '🗡', '⚔', '🔫', '🛡', '🔧', '🔩', '⚙', '🗜', '⚖', '🔗', '⛓', '🧰', '🧲', '⚗', '🧪', '🧫', '🧬', '🔬', '🔭', '📡', '💉', '💊', '🚪', '🛏', '🛋', '🚽', '🚿', '🛁', '🧴', '🧷', '🧹', '🧺', '🧻', '🧼', '🧽', '🧯', '🚬', '⚰', '⚱', '🗿', '🚰']
  );

  final Map<String, String> _symbols = new Map.fromIterables(
      ['Heart With Arrow', 'Heart With Ribbon', 'Sparkling Heart', 'Growing Heart', 'Beating Heart', 'Revolving Hearts', 'Two Hearts', 'Heart Decoration', 'Heavy Heart Exclamation', 'Broken Heart', 'Red Heart', 'Orange Heart', 'Yellow Heart', 'Green Heart', 'Blue Heart', 'Purple Heart', 'Black Heart', 'Hundred Points', 'Anger Symbol', 'Speech Balloon', 'Eye in Speech Bubble', 'Right Anger Bubble', 'Thought Balloon', 'Zzz', 'White Flower', 'Hot Springs', 'Barber Pole', 'Stop Sign', 'Twelve O’Clock', 'Twelve-Thirty', 'One O’Clock', 'One-Thirty', 'Two O’Clock', 'Two-Thirty', 'Three O’Clock', 'Three-Thirty', 'Four O’Clock', 'Four-Thirty', 'Five O’Clock', 'Five-Thirty', 'Six O’Clock', 'Six-Thirty', 'Seven O’Clock', 'Seven-Thirty', 'Eight O’Clock', 'Eight-Thirty', 'Nine O’Clock', 'Nine-Thirty', 'Ten O’Clock', 'Ten-Thirty', 'Eleven O’Clock', 'Eleven-Thirty', 'Cyclone', 'Spade Suit', 'Heart Suit', 'Diamond Suit', 'Club Suit', 'Joker', 'Mahjong Red Dragon', 'Flower Playing Cards', 'Muted Speaker', 'Speaker Low Volume', 'Speaker Medium Volume', 'Speaker High Volume', 'Loudspeaker', 'Megaphone', 'Postal Horn', 'Bell', 'Bell With Slash', 'Musical Note', 'Musical Notes', 'ATM Sign', 'Litter in Bin Sign', 'Potable Water', 'Wheelchair Symbol', 'Men’s Room', 'Women’s Room', 'Restroom', 'Baby Symbol', 'Water Closet', 'Warning', 'Children Crossing', 'No Entry', 'Prohibited', 'No Bicycles', 'No Smoking', 'No Littering', 'Non-Potable Water', 'No Pedestrians', 'No One Under Eighteen', 'Radioactive', 'Biohazard', 'Up Arrow', 'Up-Right Arrow', 'Right Arrow', 'Down-Right Arrow', 'Down Arrow', 'Down-Left Arrow', 'Left Arrow', 'Up-Left Arrow', 'Up-Down Arrow', 'Left-Right Arrow', 'Right Arrow Curving Left', 'Left Arrow Curving Right', 'Right Arrow Curving Up', 'Right Arrow Curving Down', 'Clockwise Vertical Arrows', 'Counterclockwise Arrows Button', 'Back Arrow', 'End Arrow', 'On! Arrow', 'Soon Arrow', 'Top Arrow', 'Place of Worship', 'Atom Symbol', 'Om', 'Star of David', 'Wheel of Dharma', 'Yin Yang', 'Latin Cross', 'Orthodox Cross', 'Star and Crescent', 'Peace Symbol', 'Menorah', 'Dotted Six-Pointed Star', 'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces', 'Ophiuchus', 'Shuffle Tracks Button', 'Repeat Button', 'Repeat Single Button', 'Play Button', 'Fast-Forward Button', 'Reverse Button', 'Fast Reverse Button', 'Upwards Button', 'Fast Up Button', 'Downwards Button', 'Fast Down Button', 'Stop Button', 'Eject Button', 'Cinema', 'Dim Button', 'Bright Button', 'Antenna Bars', 'Vibration Mode', 'Mobile Phone Off', 'Infinity', 'Recycling Symbol', 'Trident Emblem', 'Name Badge', 'Japanese Symbol for Beginner', 'Heavy Large Circle', 'White Heavy Check Mark', 'Ballot Box With Check', 'Heavy Check Mark', 'Heavy Multiplication X', 'Cross Mark', 'Cross Mark Button', 'Heavy Plus Sign', 'Heavy Minus Sign', 'Heavy Division Sign', 'Curly Loop', 'Double Curly Loop', 'Part Alternation Mark', 'Eight-Spoked Asterisk', 'Eight-Pointed Star', 'Sparkle', 'Double Exclamation Mark', 'Exclamation Question Mark', 'Question Mark', 'White Question Mark', 'White Exclamation Mark', 'Exclamation Mark', 'Copyright', 'Registered', 'Trade Mark', 'Keycap Number Sign', 'Keycap Digit Zero', 'Keycap Digit One', 'Keycap Digit Two', 'Keycap Digit Three', 'Keycap Digit Four', 'Keycap Digit Five', 'Keycap Digit Six', 'Keycap Digit Seven', 'Keycap Digit Eight', 'Keycap Digit Nine', 'Keycap: 10', 'Input Latin Uppercase', 'Input Latin Lowercase', 'Input Numbers', 'Input Symbols', 'Input Latin Letters', 'A Button (Blood Type)', 'AB Button (Blood Type)', 'B Button (Blood Type)', 'CL Button', 'Cool Button', 'Free Button', 'Information', 'ID Button', 'Circled M', 'New Button', 'NG Button', 'O Button (Blood Type)', 'OK Button', 'P Button', 'SOS Button', 'Up! Button', 'Vs Button', 'Japanese “Here” Button', 'Japanese “Service Charge” Button', 'Japanese “Monthly Amount” Button', 'Japanese “Not Free of Charge” Button', 'Japanese “Reserved” Button', 'Japanese “Bargain” Button', 'Japanese “Discount” Button', 'Japanese “Free of Charge” Button', 'Japanese “Prohibited” Button', 'Japanese “Acceptable” Button', 'Japanese “Application” Button', 'Japanese “Passing Grade” Button', 'Japanese “Vacancy” Button', 'Japanese “Congratulations” Button', 'Japanese “Secret” Button', 'Japanese “Open for Business” Button', 'Japanese “No Vacancy” Button', 'Red Circle', 'Blue Circle', 'Black Circle', 'White Circle', 'Black Large Square', 'White Large Square', 'Black Medium Square', 'White Medium Square', 'Black Medium-Small Square', 'White Medium-Small Square', 'Black Small Square', 'White Small Square', 'Large Orange Diamond', 'Large Blue Diamond', 'Small Orange Diamond', 'Small Blue Diamond', 'Red Triangle Pointed Up', 'Red Triangle Pointed Down', 'Diamond With a Dot', 'White Square Button', 'Black Square Button'],
      ['💘', '💝', '💖', '💗', '💓', '💞', '💕', '💟', '❣', '💔', '❤', '🧡', '💛', '💚', '💙', '💜', '🖤', '💯', '💢', '💬', '👁️\u200d🗨️', '🗯', '💭', '💤', '💮', '♨', '💈', '🛑', '🕛', '🕧', '🕐', '🕜', '🕑', '🕝', '🕒', '🕞', '🕓', '🕟', '🕔', '🕠', '🕕', '🕡', '🕖', '🕢', '🕗', '🕣', '🕘', '🕤', '🕙', '🕥', '🕚', '🕦', '🌀', '♠', '♥', '♦', '♣', '🃏', '🀄', '🎴', '🔇', '🔈', '🔉', '🔊', '📢', '📣', '📯', '🔔', '🔕', '🎵', '🎶', '🏧', '🚮', '🚰', '♿', '🚹', '🚺', '🚻', '🚼', '🚾', '⚠', '🚸', '⛔', '🚫', '🚳', '🚭', '🚯', '🚱', '🚷', '🔞', '☢', '☣', '⬆', '↗', '➡', '↘', '⬇', '↙', '⬅', '↖', '↕', '↔', '↩', '↪', '⤴', '⤵', '🔃', '🔄', '🔙', '🔚', '🔛', '🔜', '🔝', '🛐', '⚛', '🕉', '✡', '☸', '☯', '✝', '☦', '☪', '☮', '🕎', '🔯', '♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓', '⛎', '🔀', '🔁', '🔂', '▶', '⏩', '◀', '⏪', '🔼', '⏫', '🔽', '⏬', '⏹', '⏏', '🎦', '🔅', '🔆', '📶', '📳', '📴', '♾', '♻', '🔱', '📛', '🔰', '⭕', '✅', '☑', '✔', '✖', '❌', '❎', '➕', '➖', '➗', '➰', '➿', '〽', '✳', '✴', '❇', '‼', '⁉', '❓', '❔', '❕', '❗', '©', '®', '™', '#️⃣', '0️⃣', '1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣', '7️⃣', '8️⃣', '9️⃣', '🔟', '🔠', '🔡', '🔢', '🔣', '🔤', '🅰', '🆎', '🅱', '🆑', '🆒', '🆓', 'ℹ', '🆔', 'Ⓜ', '🆕', '🆖', '🅾', '🆗', '🅿', '🆘', '🆙', '🆚', '🈁', '🈂', '🈷', '🈶', '🈯', '🉐', '🈹', '🈚', '🈲', '🉑', '🈸', '🈴', '🈳', '㊗', '㊙', '🈺', '🈵', '🔴', '🔵', '⚫', '⚪', '⬛', '⬜', '◼', '◻', '◾', '◽', '▪', '▫', '🔶', '🔷', '🔸', '🔹', '🔺', '🔻', '💠', '🔳', '🔲']
  );
  final Map<String, String> _flags = new Map.fromIterables(
      ['Chequered Flag', 'Triangular Flag', 'Crossed Flags', 'Black Flag', 'White Flag', 'Rainbow Flag', 'Pirate Flag', 'Ascension Island', 'Andorra', 'United Arab Emirates', 'Afghanistan', 'Antigua &amp; Barbuda', 'Anguilla', 'Albania', 'Armenia', 'Angola', 'Antarctica', 'Argentina', 'American Samoa', 'Austria', 'Australia', 'Aruba', 'Åland Islands', 'Azerbaijan', 'Bosnia &amp; Herzegovina', 'Barbados', 'Bangladesh', 'Belgium', 'Burkina Faso', 'Bulgaria', 'Bahrain', 'Burundi', 'Benin', 'St. Barthélemy', 'Bermuda', 'Brunei', 'Bolivia', 'Caribbean Netherlands', 'Brazil', 'Bahamas', 'Bhutan', 'Bouvet Island', 'Botswana', 'Belarus', 'Belize', 'Canada', 'Cocos (Keeling) Islands', 'Congo - Kinshasa', 'Central African Republic', 'Congo - Brazzaville', 'Switzerland', 'Côte d’Ivoire', 'Cook Islands', 'Chile', 'Cameroon', 'China', 'Colombia', 'Clipperton Island', 'Costa Rica', 'Cuba', 'Cape Verde', 'Curaçao', 'Christmas Island', 'Cyprus', 'Czechia', 'Germany', 'Diego Garcia', 'Djibouti', 'Denmark', 'Dominica', 'Dominican Republic', 'Algeria', 'Ceuta &amp; Melilla', 'Ecuador', 'Estonia', 'Egypt', 'Western Sahara', 'Eritrea', 'Spain', 'Ethiopia', 'European Union', 'Finland', 'Fiji', 'Falkland Islands', 'Micronesia', 'Faroe Islands', 'France', 'Gabon', 'United Kingdom', 'Grenada', 'Georgia', 'French Guiana', 'Guernsey', 'Ghana', 'Gibraltar', 'Greenland', 'Gambia', 'Guinea', 'Guadeloupe', 'Equatorial Guinea', 'Greece', 'South Georgia &amp; South Sandwich Islands', 'Guatemala', 'Guam', 'Guinea-Bissau', 'Guyana', 'Hong Kong SAR China', 'Heard &amp; McDonald Islands', 'Honduras', 'Croatia', 'Haiti', 'Hungary', 'Canary Islands', 'Indonesia', 'Ireland', 'Israel', 'Isle of Man', 'India', 'British Indian Ocean Territory', 'Iraq', 'Iran', 'Iceland', 'Italy', 'Jersey', 'Jamaica', 'Jordan', 'Japan', 'Kenya', 'Kyrgyzstan', 'Cambodia', 'Kiribati', 'Comoros', 'St. Kitts &amp; Nevis', 'North Korea', 'South Korea', 'Kuwait', 'Cayman Islands', 'Kazakhstan', 'Laos', 'Lebanon', 'St. Lucia', 'Liechtenstein', 'Sri Lanka', 'Liberia', 'Lesotho', 'Lithuania', 'Luxembourg', 'Latvia', 'Libya', 'Morocco', 'Monaco', 'Moldova', 'Montenegro', 'St. Martin', 'Madagascar', 'Marshall Islands', 'North Macedonia', 'Mali', 'Myanmar (Burma)', 'Mongolia', 'Macau Sar China', 'Northern Mariana Islands', 'Martinique', 'Mauritania', 'Montserrat', 'Malta', 'Mauritius', 'Maldives', 'Malawi', 'Mexico', 'Malaysia', 'Mozambique', 'Namibia', 'New Caledonia', 'Niger', 'Norfolk Island', 'Nigeria', 'Nicaragua', 'Netherlands', 'Norway', 'Nepal', 'Nauru', 'Niue', 'New Zealand', 'Oman', 'Panama', 'Peru', 'French Polynesia', 'Papua New Guinea', 'Philippines', 'Pakistan', 'Poland', 'St. Pierre &amp; Miquelon', 'Pitcairn Islands', 'Puerto Rico', 'Palestinian Territories', 'Portugal', 'Palau', 'Paraguay', 'Qatar', 'Réunion', 'Romania', 'Serbia', 'Russia', 'Rwanda', 'Saudi Arabia', 'Solomon Islands', 'Seychelles', 'Sudan', 'Sweden', 'Singapore', 'St. Helena', 'Slovenia', 'Svalbard &amp; Jan Mayen', 'Slovakia', 'Sierra Leone', 'San Marino', 'Senegal', 'Somalia', 'Suriname', 'South Sudan', 'São Tomé &amp; Príncipe', 'El Salvador', 'Sint Maarten', 'Syria', 'Swaziland', 'Tristan Da Cunha', 'Turks &amp; Caicos Islands', 'Chad', 'French Southern Territories', 'Togo', 'Thailand', 'Tajikistan', 'Tokelau', 'Timor-Leste', 'Turkmenistan', 'Tunisia', 'Tonga', 'Turkey', 'Trinidad &amp; Tobago', 'Tuvalu', 'Taiwan', 'Tanzania', 'Ukraine', 'Uganda', 'U.S. Outlying Islands', 'United Nations', 'United States', 'Uruguay', 'Uzbekistan', 'Vatican City', 'St. Vincent &amp; Grenadines', 'Venezuela', 'British Virgin Islands', 'U.S. Virgin Islands', 'Vietnam', 'Vanuatu', 'Wallis &amp; Futuna', 'Samoa', 'Kosovo', 'Yemen', 'Mayotte', 'South Africa', 'Zambia', 'Zimbabwe'],
      ['🏁', '🚩', '🎌', '🏴', '🏳', '🏳️\u200d🌈', '🏴\u200d☠️', '🇦🇨', '🇦🇩', '🇦🇪', '🇦🇫', '🇦🇬', '🇦🇮', '🇦🇱', '🇦🇲', '🇦🇴', '🇦🇶', '🇦🇷', '🇦🇸', '🇦🇹', '🇦🇺', '🇦🇼', '🇦🇽', '🇦🇿', '🇧🇦', '🇧🇧', '🇧🇩', '🇧🇪', '🇧🇫', '🇧🇬', '🇧🇭', '🇧🇮', '🇧🇯', '🇧🇱', '🇧🇲', '🇧🇳', '🇧🇴', '🇧🇶', '🇧🇷', '🇧🇸', '🇧🇹', '🇧🇻', '🇧🇼', '🇧🇾', '🇧🇿', '🇨🇦', '🇨🇨', '🇨🇩', '🇨🇫', '🇨🇬', '🇨🇭', '🇨🇮', '🇨🇰', '🇨🇱', '🇨🇲', '🇨🇳', '🇨🇴', '🇨🇵', '🇨🇷', '🇨🇺', '🇨🇻', '🇨🇼', '🇨🇽', '🇨🇾', '🇨🇿', '🇩🇪', '🇩🇬', '🇩🇯', '🇩🇰', '🇩🇲', '🇩🇴', '🇩🇿', '🇪🇦', '🇪🇨', '🇪🇪', '🇪🇬', '🇪🇭', '🇪🇷', '🇪🇸', '🇪🇹', '🇪🇺', '🇫🇮', '🇫🇯', '🇫🇰', '🇫🇲', '🇫🇴', '🇫🇷', '🇬🇦', '🇬🇧', '🇬🇩', '🇬🇪', '🇬🇫', '🇬🇬', '🇬🇭', '🇬🇮', '🇬🇱', '🇬🇲', '🇬🇳', '🇬🇵', '🇬🇶', '🇬🇷', '🇬🇸', '🇬🇹', '🇬🇺', '🇬🇼', '🇬🇾', '🇭🇰', '🇭🇲', '🇭🇳', '🇭🇷', '🇭🇹', '🇭🇺', '🇮🇨', '🇮🇩', '🇮🇪', '🇮🇱', '🇮🇲', '🇮🇳', '🇮🇴', '🇮🇶', '🇮🇷', '🇮🇸', '🇮🇹', '🇯🇪', '🇯🇲', '🇯🇴', '🇯🇵', '🇰🇪', '🇰🇬', '🇰🇭', '🇰🇮', '🇰🇲', '🇰🇳', '🇰🇵', '🇰🇷', '🇰🇼', '🇰🇾', '🇰🇿', '🇱🇦', '🇱🇧', '🇱🇨', '🇱🇮', '🇱🇰', '🇱🇷', '🇱🇸', '🇱🇹', '🇱🇺', '🇱🇻', '🇱🇾', '🇲🇦', '🇲🇨', '🇲🇩', '🇲🇪', '🇲🇫', '🇲🇬', '🇲🇭', '🇲🇰', '🇲🇱', '🇲🇲', '🇲🇳', '🇲🇴', '🇲🇵', '🇲🇶', '🇲🇷', '🇲🇸', '🇲🇹', '🇲🇺', '🇲🇻', '🇲🇼', '🇲🇽', '🇲🇾', '🇲🇿', '🇳🇦', '🇳🇨', '🇳🇪', '🇳🇫', '🇳🇬', '🇳🇮', '🇳🇱', '🇳🇴', '🇳🇵', '🇳🇷', '🇳🇺', '🇳🇿', '🇴🇲', '🇵🇦', '🇵🇪', '🇵🇫', '🇵🇬', '🇵🇭', '🇵🇰', '🇵🇱', '🇵🇲', '🇵🇳', '🇵🇷', '🇵🇸', '🇵🇹', '🇵🇼', '🇵🇾', '🇶🇦', '🇷🇪', '🇷🇴', '🇷🇸', '🇷🇺', '🇷🇼', '🇸🇦', '🇸🇧', '🇸🇨', '🇸🇩', '🇸🇪', '🇸🇬', '🇸🇭', '🇸🇮', '🇸🇯', '🇸🇰', '🇸🇱', '🇸🇲', '🇸🇳', '🇸🇴', '🇸🇷', '🇸🇸', '🇸🇹', '🇸🇻', '🇸🇽', '🇸🇾', '🇸🇿', '🇹🇦', '🇹🇨', '🇹🇩', '🇹🇫', '🇹🇬', '🇹🇭', '🇹🇯', '🇹🇰', '🇹🇱', '🇹🇲', '🇹🇳', '🇹🇴', '🇹🇷', '🇹🇹', '🇹🇻', '🇹🇼', '🇹🇿', '🇺🇦', '🇺🇬', '🇺🇲', '🇺🇳', '🇺🇸', '🇺🇾', '🇺🇿', '🇻🇦', '🇻🇨', '🇻🇪', '🇻🇬', '🇻🇮', '🇻🇳', '🇻🇺', '🇼🇫', '🇼🇸', '🇽🇰', '🇾🇪', '🇾🇹', '🇿🇦', '🇿🇲', '🇿🇼']
  );

}

class _Recommended {

  final String name;
  final String emoji;
  final int tier;
  final int numSplitEqualKeyword;
  final int numSplitPartialKeyword;

  _Recommended({
    this.name,
    this.emoji,
    this.tier,
    this.numSplitEqualKeyword = 0,
    this.numSplitPartialKeyword = 0
  });

}

class CategoryIcon {

  final IconData icon;
  final Color color;
  final Color selectedColor;

  CategoryIcon ({
    @required this.icon,
    this.color = Colors.black12,
    this.selectedColor = Colors.black26
  });

}

class CategoryIcons {

  CategoryIcon recommendationIcon;
  CategoryIcon smileyIcon;
  CategoryIcon animalIcon;
  CategoryIcon foodIcon;
  CategoryIcon travelIcon;
  CategoryIcon activityIcon;
  CategoryIcon objectIcon;
  CategoryIcon symbolIcon;
  CategoryIcon flagIcon;

  CategoryIcons ({
    this.recommendationIcon,
    this.smileyIcon,
    this.animalIcon,
    this.foodIcon,
    this.travelIcon,
    this.activityIcon,
    this.objectIcon,
    this.symbolIcon,
    this.flagIcon
  }) {

    if (recommendationIcon == null) {
      recommendationIcon = CategoryIcon(icon: Icons.history);
    }
    if (smileyIcon == null) {
      smileyIcon = CategoryIcon(icon: Icons.tag_faces);
    }
    if (animalIcon == null) {
      animalIcon = CategoryIcon(icon: Icons.pets);
    }
    if (foodIcon == null) {
      foodIcon = CategoryIcon(icon: Icons.fastfood);
    }
    if (travelIcon == null) {
      travelIcon = CategoryIcon(icon: Icons.location_city);
    }
    if (activityIcon == null) {
      activityIcon = CategoryIcon(icon: Icons.directions_run);
    }
    if (objectIcon == null) {
      objectIcon = CategoryIcon(icon: Icons.lightbulb_outline);
    }
    if (symbolIcon == null) {
      symbolIcon = CategoryIcon(icon: Icons.euro_symbol);
    }
    if (flagIcon == null) {
      flagIcon = CategoryIcon(icon: Icons.flag);
    }

  }

}

class Emoji {

  final String name;
  final String emoji;

  Emoji ({
    @required this.name,
    @required this.emoji
  });

  @override
  String toString() {
    return "Name: " + name + ", Emoji: " + emoji;
  }

}

class _EmojiPickerState extends State<EmojiPicker> {
  List<String> historyEmojis = new List();

  @override
  void initState() {
    super.initState();
    getEmojiHistory().then((emojis) {
      historyEmojis = emojis;
    });
  }

  /// Returns the emoji history of the user
  Future<dynamic> getEmojiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('lastSelectedEmojis')) {
      return prefs.getStringList('lastSelectedEmojis');
    } else {
      prefs.setStringList('lastSelectedEmojis', []);
      return prefs.getStringList('lastSelectedEmojis');
    }
  }

  /// Adds an emoji to the users history, if it was selected
  void addEmojiToHistory(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = await getEmojiHistory();
    /// Removes the last frequently used emoji, so it's not bigger as numRecommended
    if (history.length >= widget.numRecommended) {
      history.removeLast();
    }
    /// Removes the selected Emoji, if it was selected before
    history.remove(emoji);
    /// Adds the emoji at the first index, so it will appear as the last used emoji
    history.insert(0, emoji);
    prefs.setStringList('lastSelectedEmojis', history);
    
    setState(() {
      historyEmojis = history;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    int recommendedPagesNum = 0;
    List<_Recommended> recommendedEmojis = new List();
    List<Widget> recommendedPages = new List();
    
    Map<String, String> allObjects = new Map();
    allObjects.addAll(widget._smileys);
    allObjects.addAll(widget._animals);
    allObjects.addAll(widget._foods);
    allObjects.addAll(widget._travel);
    allObjects.addAll(widget._activities);
    allObjects.addAll(widget._objects);
    allObjects.addAll(widget._symbols);
    allObjects.addAll(widget._flags);

    allObjects.forEach((key, value) {
      historyEmojis.forEach((emoji) {
        if (value == emoji) {
          recommendedEmojis.add(_Recommended(name: key, emoji: emoji, tier: 1));
        }
      });
    });


    if (recommendedEmojis.length > widget.numRecommended) {
      recommendedEmojis = recommendedEmojis.getRange(0, widget.numRecommended).toList();
    }

    if (recommendedEmojis.length != 0) {
      recommendedPagesNum = (recommendedEmojis.length / (widget.rows * widget.columns)).ceil();

      for (var i = 0; i < recommendedPagesNum; i++) {

        recommendedPages.add(
            Container(
              color: widget.bgColor,
              child: GridView.count(
                shrinkWrap: true,
                primary: true,
                physics: AlwaysScrollableScrollPhysics(),
                crossAxisCount: widget.columns,
                children: List.generate(recommendedEmojis.length, (index) {
                    switch (widget.buttonMode) {
                      case ButtonMode.MATERIAL:
                        return Center(
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Center(
                                child: Text(recommendedEmojis[index].emoji, style: TextStyle(fontSize: 24),),
                              ),
                              onPressed: () {
                                _Recommended recommended = recommendedEmojis[index];
                                addEmojiToHistory(recommended.emoji);
                                widget.onEmojiSelected(Emoji(name: recommended.name, emoji: recommended.emoji), widget.selectedCategory);
                              },
                            )
                        );
                        break;
                      case ButtonMode.CUPERTINO:

                        return Center(
                            child: CupertinoButton(
                              pressedOpacity: 0.4,
                              padding: EdgeInsets.all(0),
                              child: Center(
                                child: Text(recommendedEmojis[index].emoji, style: TextStyle(fontSize: 24),),
                              ),
                              onPressed: () {
                                _Recommended recommended = recommendedEmojis[index];
                                addEmojiToHistory(recommended.emoji);
                                widget.onEmojiSelected(Emoji(name: recommended.name, emoji: recommended.emoji), widget.selectedCategory);
                              },
                            )
                        );

                        break;
                    }
                }),
              ),
            )
        );

      }
    } else {
      recommendedPagesNum = 1;

      if (widget.selectedCategory == Category.RECOMMENDED) {
        widget.selectedCategory = Category.SMILEYS;
      }

      recommendedPages.add(
        Container(
          color: widget.bgColor,
            child: Center(
                child: Text(widget.noRecommendationsText, style: widget.noRecommendationsStyle,)
            )
        )
      );
    }

    int smileyPagesNum = (widget._smileys.values.toList().length / (widget.rows * widget.columns)).ceil();

    List<Widget> smileyPages = new List();

    for (var i = 0; i < smileyPagesNum; i++) {

      smileyPages.add(
          Container(
            color: widget.bgColor,
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: widget.columns,
              children: List.generate(widget.rows * widget.columns, (index) {
                if (index + (widget.columns * widget.rows * i) < widget._smileys.values.toList().length) {

                  switch (widget.buttonMode) {
                    case ButtonMode.MATERIAL:
                      return Center(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._smileys.values.toList()[index + (widget.columns * widget.rows * i)], style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: () {
                              addEmojiToHistory(widget._smileys.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._smileys.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._smileys.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                    case ButtonMode.CUPERTINO:
                      return Center(
                          child: CupertinoButton(
                            pressedOpacity: 0.4,
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._smileys.values.toList()[index + (widget.columns * widget.rows * i)], style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: () {
                              addEmojiToHistory(widget._smileys.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._smileys.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._smileys.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                  }
                } else {
                  return Container();
                }
              }),
            ),
          )
      );
    }

    int animalPagesNum = (widget._animals.values.toList().length / (widget.rows * widget.columns)).ceil();

    List<Widget> animalPages = new List();

    for (var i = 0; i < animalPagesNum; i++) {
      animalPages.add(
          Container(
            color: widget.bgColor,
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: widget.columns,
              children: List.generate(widget.rows * widget.columns, (index) {
                if (index + (widget.columns * widget.rows * i) < widget._animals.values.toList().length) {

                  switch (widget.buttonMode) {
                    case ButtonMode.MATERIAL:
                      return Center(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._animals.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._animals.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._animals.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._animals.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                    case ButtonMode.CUPERTINO:
                      return Center(
                          child: CupertinoButton(
                            pressedOpacity: 0.4,
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._animals.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._animals.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._animals.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._animals.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                  }

                } else {
                  return Container();
                }
              }),
            ),
          )
      );
    }

    int foodPagesNum = (widget._foods.values.toList().length / (widget.rows * widget.columns)).ceil();

    List<Widget> foodPages = new List();

    for (var i = 0; i < foodPagesNum; i++) {
      foodPages.add(
          Container(
            color: widget.bgColor,
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: widget.columns,
              children: List.generate(widget.rows * widget.columns, (index) {
                if (index + (widget.columns * widget.rows * i) < widget._foods.values.toList().length) {

                  switch (widget.buttonMode) {
                    case ButtonMode.MATERIAL:
                      return Center(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._foods.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._foods.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._foods.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._foods.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                    case ButtonMode.CUPERTINO:
                      return Center(
                          child: CupertinoButton(
                            pressedOpacity: 0.4,
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._foods.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._foods.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._foods.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._foods.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                  }

                } else {
                  return Container();
                }
              }),
            ),
          )
      );
    }

    int travelPagesNum = (widget._travel.values.toList().length / (widget.rows * widget.columns)).ceil();

    List<Widget> travelPages = new List();

    for (var i = 0; i < travelPagesNum; i++) {
      travelPages.add(
          Container(
            color: widget.bgColor,
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: widget.columns,
              children: List.generate(widget.rows * widget.columns, (index) {
                if (index + (widget.columns * widget.rows * i) < widget._travel.values.toList().length) {

                  switch (widget.buttonMode) {
                    case ButtonMode.MATERIAL:
                      return Center(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._travel.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._travel.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._travel.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._travel.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                    case ButtonMode.CUPERTINO:
                      return Center(
                          child: CupertinoButton(
                            pressedOpacity: 0.4,
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._travel.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._travel.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._travel.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._travel.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                  }

                } else {
                  return Container();
                }
              }),
            ),
          )
      );
    }

    int activityPagesNum = (widget._activities.values.toList().length / (widget.rows * widget.columns)).ceil();

    List<Widget> activityPages = new List();

    for (var i = 0; i < activityPagesNum; i++) {
      activityPages.add(
          Container(
            color: widget.bgColor,
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: widget.columns,
              children: List.generate(widget.rows * widget.columns, (index) {
                if (index + (widget.columns * widget.rows * i) < widget._activities.values.toList().length) {

                  switch (widget.buttonMode) {
                    case ButtonMode.MATERIAL:
                      return Center(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._activities.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._activities.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._activities.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._activities.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                    case ButtonMode.CUPERTINO:
                      return Center(
                          child: CupertinoButton(
                            pressedOpacity: 0.4,
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._activities.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._activities.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._activities.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._activities.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                  }

                } else {
                  return Container();
                }
              }),
            ),
          )
      );
    }

    int objectPagesNum = (widget._objects.values.toList().length / (widget.rows * widget.columns)).ceil();

    List<Widget> objectPages = new List();

    for (var i = 0; i < objectPagesNum; i++) {
      objectPages.add(
          Container(
            color: widget.bgColor,
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: widget.columns,
              children: List.generate(widget.rows * widget.columns, (index) {
                if (index + (widget.columns * widget.rows * i) < widget._objects.values.toList().length) {

                  switch (widget.buttonMode) {
                    case ButtonMode.MATERIAL:
                      return Center(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._objects.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._objects.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._objects.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._objects.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                    case ButtonMode.CUPERTINO:
                      return Center(
                          child: CupertinoButton(
                            pressedOpacity: 0.4,
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._objects.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._objects.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._objects.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._objects.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                  }

                } else {
                  return Container();
                }
              }),
            ),
          )
      );
    }

    int symbolPagesNum = (widget._symbols.values.toList().length / (widget.rows * widget.columns)).ceil();

    List<Widget> symbolPages = new List();

    for (var i = 0; i < symbolPagesNum; i++) {
      symbolPages.add(
          Container(
            color: widget.bgColor,
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: widget.columns,
              children: List.generate(widget.rows * widget.columns, (index) {
                if (index + (widget.columns * widget.rows * i) < widget._symbols.values.toList().length) {

                  switch (widget.buttonMode) {
                    case ButtonMode.MATERIAL:
                      return Center(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._symbols.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._symbols.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._symbols.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._symbols.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                    case ButtonMode.CUPERTINO:
                      return Center(
                          child: CupertinoButton(
                            pressedOpacity: 0.4,
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._symbols.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._symbols.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._symbols.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._symbols.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                  }

                } else {
                  return Container();
                }
              }),
            ),
          )
      );
    }

    int flagPagesNum = (widget._flags.values.toList().length / (widget.rows * widget.columns)).ceil();

    List<Widget> flagPages = new List();

    for (var i = 0; i < flagPagesNum; i++) {
      flagPages.add(
          Container(
            color: widget.bgColor,
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: widget.columns,
              children: List.generate(widget.rows * widget.columns, (index) {
                if (index + (widget.columns * widget.rows * i) < widget._flags.values.toList().length) {

                  switch (widget.buttonMode) {
                    case ButtonMode.MATERIAL:
                      return Center(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._flags.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._flags.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._flags.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._flags.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                    case ButtonMode.CUPERTINO:
                      return Center(
                          child: CupertinoButton(
                            pressedOpacity: 0.4,
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(widget._flags.values.toList()[index + (widget.columns * widget.rows * i)],
                                style: TextStyle(fontSize: 24),),
                            ),
                            onPressed: (){
                              addEmojiToHistory(widget._flags.values.toList()[index + (widget.columns * widget.rows * i)]);
                              widget.onEmojiSelected(Emoji(name: widget._flags.keys.toList()[index + (widget.columns * widget.rows * i)], emoji: widget._flags.values.toList()[index + (widget.columns * widget.rows * i)]), widget.selectedCategory);
                            },
                          )
                      );
                      break;
                  }

                } else {
                  return Container();
                }
              }),
            ),
          )
      );
    }

    List<Widget> pages = new List();
    pages.addAll(recommendedPages);
    pages.addAll(smileyPages);
    pages.addAll(animalPages);
    pages.addAll(foodPages);
    pages.addAll(travelPages);
    pages.addAll(activityPages);
    pages.addAll(objectPages);
    pages.addAll(symbolPages);
    pages.addAll(flagPages);

    PageController pageController;
    if (widget.selectedCategory == Category.RECOMMENDED) {
      pageController = PageController(initialPage: 0);
    } else if (widget.selectedCategory == Category.SMILEYS) {
      pageController = PageController(initialPage: recommendedPagesNum);
    } else if (widget.selectedCategory == Category.ANIMALS) {
      pageController = PageController(initialPage: smileyPagesNum + recommendedPagesNum);
    } else if (widget.selectedCategory == Category.FOODS) {
      pageController = PageController(initialPage: smileyPagesNum + animalPagesNum + recommendedPagesNum);
    } else if (widget.selectedCategory == Category.TRAVEL) {
      pageController = PageController(initialPage: smileyPagesNum + animalPagesNum + foodPagesNum + recommendedPagesNum);
    } else if (widget.selectedCategory == Category.ACTIVITIES) {
      pageController = PageController(initialPage: smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + recommendedPagesNum);
    } else if (widget.selectedCategory == Category.OBJECTS) {
      pageController = PageController(initialPage: smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + activityPagesNum + recommendedPagesNum);
    } else if (widget.selectedCategory == Category.SYMBOLS) {
      pageController = PageController(initialPage: smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + activityPagesNum + objectPagesNum + recommendedPagesNum);
    } else if (widget.selectedCategory == Category.FLAGS) {
      pageController = PageController(initialPage: smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + activityPagesNum + objectPagesNum + symbolPagesNum + recommendedPagesNum);
    }
    pageController.addListener(() {
      setState(() {
        getEmojiHistory().then((emojis) {
          historyEmojis = emojis;
        });
      });
    });

    return Column(
      children: <Widget>[
        SizedBox(
          height: (MediaQuery.of(context).size.width / widget.columns) * widget.rows,
          width: MediaQuery.of(context).size.width,
          child: PageView (
              physics: AlwaysScrollableScrollPhysics(),
              children: pages,
              controller: pageController,
              onPageChanged: (index) {
                if (index < recommendedPagesNum) {
                  widget.selectedCategory = Category.RECOMMENDED;
                } else if (index < smileyPagesNum + recommendedPagesNum) {
                  widget.selectedCategory = Category.SMILEYS;
                } else if (index < smileyPagesNum + animalPagesNum + recommendedPagesNum) {
                  widget.selectedCategory = Category.ANIMALS;
                } else if (index < smileyPagesNum + animalPagesNum + foodPagesNum + recommendedPagesNum) {
                  widget.selectedCategory = Category.FOODS;
                } else if (index < smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + recommendedPagesNum) {
                  widget.selectedCategory = Category.TRAVEL;
                } else if (index < smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + activityPagesNum + recommendedPagesNum) {
                  widget.selectedCategory = Category.ACTIVITIES;
                } else if (index < smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + activityPagesNum + objectPagesNum + recommendedPagesNum) {
                  widget.selectedCategory = Category.OBJECTS;
                } else if (index < smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + activityPagesNum + objectPagesNum + symbolPagesNum + recommendedPagesNum) {
                  widget.selectedCategory = Category.SYMBOLS;
                } else {
                  widget.selectedCategory = Category.FLAGS;
                }
                setState(() {
                  getEmojiHistory().then((emojis) {
                    historyEmojis = emojis;
                  });
                });
              }
          ),
        ),
        Container(
          color: widget.bgColor,
          height: 6,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 4, bottom: 0, right: 2, left: 2),
          child: CustomPaint(
            painter: _ProgressPainter(
                context,
                pageController,
                new Map.fromIterables(
                    [Category.RECOMMENDED, Category.SMILEYS, Category.ANIMALS, Category.FOODS, Category.TRAVEL, Category.ACTIVITIES, Category.OBJECTS, Category.SYMBOLS, Category.FLAGS],
                    [recommendedPagesNum, smileyPagesNum, animalPagesNum, foodPagesNum, travelPagesNum, activityPagesNum, objectPagesNum, symbolPagesNum, flagPagesNum]
                ),
                widget.selectedCategory,
                widget.indicatorColor
            ),
          )
        ),
        Container(
            padding: EdgeInsets.only(bottom: 10),
            height: 50,
            color: widget.bgColor,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: 
                  widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.RECOMMENDED ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.recommendationIcon.icon, size: 22, color: widget.selectedCategory == Category.RECOMMENDED ? widget.categoryIcons.recommendationIcon.selectedColor : widget.categoryIcons.recommendationIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.RECOMMENDED) {
                        return;
                      }

                      pageController.jumpToPage(0);


                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.RECOMMENDED ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.recommendationIcon.icon, size: 22, color: widget.selectedCategory == Category.RECOMMENDED ? widget.categoryIcons.recommendationIcon.selectedColor : widget.categoryIcons.recommendationIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.RECOMMENDED) {
                        return;
                      }

                      pageController.jumpToPage(0);


                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.SMILEYS ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.smileyIcon.icon, size: 22, color: widget.selectedCategory == Category.SMILEYS ? widget.categoryIcons.smileyIcon.selectedColor : widget.categoryIcons.smileyIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.SMILEYS) {
                        return;
                      }

                      pageController.jumpToPage(0 + recommendedPagesNum);


                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.SMILEYS ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.smileyIcon.icon, size: 22, color: widget.selectedCategory == Category.SMILEYS ? widget.categoryIcons.smileyIcon.selectedColor : widget.categoryIcons.smileyIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.SMILEYS) {
                        return;
                      }

                      pageController.jumpToPage(0 + recommendedPagesNum);


                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.ANIMALS ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.animalIcon.icon, size: 22, color: widget.selectedCategory == Category.ANIMALS ? widget.categoryIcons.animalIcon.selectedColor : widget.categoryIcons.animalIcon.color,),
                    ),
                    onPressed: (){

                      if (widget.selectedCategory == Category.ANIMALS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + recommendedPagesNum);

                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.ANIMALS ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.animalIcon.icon, size: 22, color: widget.selectedCategory == Category.ANIMALS ? widget.categoryIcons.animalIcon.selectedColor : widget.categoryIcons.animalIcon.color,),
                    ),
                    onPressed: (){

                      if (widget.selectedCategory == Category.ANIMALS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + recommendedPagesNum);

                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.FOODS ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.foodIcon.icon, size: 22, color: widget.selectedCategory == Category.FOODS ? widget.categoryIcons.foodIcon.selectedColor : widget.categoryIcons.foodIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.FOODS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + recommendedPagesNum);


                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.FOODS ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.foodIcon.icon, size: 22, color: widget.selectedCategory == Category.FOODS ? widget.categoryIcons.foodIcon.selectedColor : widget.categoryIcons.foodIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.FOODS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + recommendedPagesNum);


                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.TRAVEL ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.travelIcon.icon, size: 22, color: widget.selectedCategory == Category.TRAVEL ? widget.categoryIcons.travelIcon.selectedColor : widget.categoryIcons.travelIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.TRAVEL) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + recommendedPagesNum);


                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.TRAVEL ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.travelIcon.icon, size: 22, color: widget.selectedCategory == Category.TRAVEL ? widget.categoryIcons.travelIcon.selectedColor : widget.categoryIcons.travelIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.TRAVEL) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + recommendedPagesNum);


                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.ACTIVITIES ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.activityIcon.icon, size: 22, color: widget.selectedCategory == Category.ACTIVITIES ? widget.categoryIcons.activityIcon.selectedColor : widget.categoryIcons.activityIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.ACTIVITIES) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + recommendedPagesNum);


                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.ACTIVITIES ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.activityIcon.icon, size: 22, color: widget.selectedCategory == Category.ACTIVITIES ? widget.categoryIcons.activityIcon.selectedColor : widget.categoryIcons.activityIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.ACTIVITIES) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + travelPagesNum + recommendedPagesNum);


                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.OBJECTS ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.objectIcon.icon, size: 22, color: widget.selectedCategory == Category.OBJECTS ? widget.categoryIcons.objectIcon.selectedColor : widget.categoryIcons.objectIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.OBJECTS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + activityPagesNum + travelPagesNum + recommendedPagesNum);


                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.OBJECTS ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.objectIcon.icon, size: 22, color: widget.selectedCategory == Category.OBJECTS ? widget.categoryIcons.objectIcon.selectedColor : widget.categoryIcons.objectIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.OBJECTS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + activityPagesNum + travelPagesNum + recommendedPagesNum);


                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.SYMBOLS ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.symbolIcon.icon, size: 22, color: widget.selectedCategory == Category.SYMBOLS ? widget.categoryIcons.symbolIcon.selectedColor : widget.categoryIcons.symbolIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.SYMBOLS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + activityPagesNum + travelPagesNum + objectPagesNum + recommendedPagesNum);


                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.SYMBOLS ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.symbolIcon.icon, size: 22, color: widget.selectedCategory == Category.SYMBOLS ? widget.categoryIcons.symbolIcon.selectedColor : widget.categoryIcons.symbolIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.SYMBOLS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + activityPagesNum + travelPagesNum + objectPagesNum + recommendedPagesNum);


                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.width / 9,
                  child: widget.buttonMode == ButtonMode.MATERIAL ?
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.FLAGS ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))
                    ),
                    child: Center(
                      child: Icon(widget.categoryIcons.flagIcon.icon, size: 22, color: widget.selectedCategory == Category.FLAGS ? widget.categoryIcons.flagIcon.selectedColor : widget.categoryIcons.flagIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.FLAGS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + activityPagesNum + travelPagesNum + objectPagesNum + symbolPagesNum + recommendedPagesNum);


                    },
                  ) :
                  CupertinoButton(
                    pressedOpacity: 0.4,
                    padding: EdgeInsets.all(0),
                    color: widget.selectedCategory == Category.FLAGS ? Colors.black12 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: Icon(widget.categoryIcons.flagIcon.icon, size: 22, color: widget.selectedCategory == Category.FLAGS ? widget.categoryIcons.flagIcon.selectedColor : widget.categoryIcons.flagIcon.color,),
                    ),
                    onPressed: () {

                      if (widget.selectedCategory == Category.FLAGS) {
                        return;
                      }

                      pageController.jumpToPage(smileyPagesNum + animalPagesNum + foodPagesNum + activityPagesNum + travelPagesNum + objectPagesNum + symbolPagesNum + recommendedPagesNum);


                    },
                  ),
                ),
              ],
            )
        )
      ],
    );
  }

}

class _ProgressPainter extends CustomPainter {

  final BuildContext context;
  final PageController pageController;
  final Map<Category, int> pages;
  final Category selectedCategory;
  final Color indicatorColor;

  _ProgressPainter(this.context, this.pageController, this.pages, this.selectedCategory, this.indicatorColor);

  @override
  void paint(Canvas canvas, Size size) {

    double actualPageWidth = MediaQuery.of(context).size.width;
    double offsetInPages = 0;
    if (selectedCategory == Category.RECOMMENDED) {
      offsetInPages = pageController.offset / actualPageWidth;
    } else if (selectedCategory == Category.SMILEYS) {
      offsetInPages = (pageController.offset - (pages[Category.RECOMMENDED] * actualPageWidth)) / actualPageWidth;
    } else if (selectedCategory == Category.ANIMALS) {
      offsetInPages = (pageController.offset - ((pages[Category.RECOMMENDED] + pages[Category.SMILEYS]) * actualPageWidth)) / actualPageWidth;
    } else if (selectedCategory == Category.FOODS) {
      offsetInPages = (pageController.offset - ((pages[Category.RECOMMENDED] + pages[Category.SMILEYS] + pages[Category.ANIMALS]) * actualPageWidth)) / actualPageWidth;
    } else if (selectedCategory == Category.TRAVEL) {
      offsetInPages = (pageController.offset - ((pages[Category.RECOMMENDED] + pages[Category.SMILEYS] + pages[Category.ANIMALS] + pages[Category.FOODS]) * actualPageWidth)) / actualPageWidth;
    } else if (selectedCategory == Category.ACTIVITIES) {
      offsetInPages = (pageController.offset - ((pages[Category.RECOMMENDED] + pages[Category.SMILEYS] + pages[Category.ANIMALS] + pages[Category.FOODS] + pages[Category.TRAVEL]) * actualPageWidth)) / actualPageWidth;
    } else if (selectedCategory == Category.OBJECTS) {
      offsetInPages = (pageController.offset - ((pages[Category.RECOMMENDED] + pages[Category.SMILEYS] + pages[Category.ANIMALS] + pages[Category.FOODS] + pages[Category.TRAVEL] + pages[Category.ACTIVITIES]) * actualPageWidth)) / actualPageWidth;
    } else if (selectedCategory == Category.SYMBOLS) {
      offsetInPages = (pageController.offset - ((pages[Category.RECOMMENDED] + pages[Category.SMILEYS] + pages[Category.ANIMALS] + pages[Category.FOODS] + pages[Category.TRAVEL] + pages[Category.ACTIVITIES] + pages[Category.OBJECTS]) * actualPageWidth)) / actualPageWidth;
    } else if (selectedCategory == Category.FLAGS) {
      offsetInPages = (pageController.offset - ((pages[Category.RECOMMENDED] + pages[Category.SMILEYS] + pages[Category.ANIMALS] + pages[Category.FOODS] + pages[Category.TRAVEL] + pages[Category.ACTIVITIES] + pages[Category.OBJECTS] + pages[Category.SYMBOLS]) * actualPageWidth)) / actualPageWidth;
    }
    double indicatorPageWidth = size.width / pages[selectedCategory];


    Rect bgRect = Offset(0, 0) & size;

    Rect indicator = Offset(max(0, offsetInPages * indicatorPageWidth), 0) & Size(indicatorPageWidth - max(0, (indicatorPageWidth + (offsetInPages * indicatorPageWidth)) - size.width) + min(0, offsetInPages * indicatorPageWidth), size.height);


    canvas.drawRect(bgRect, Paint()..color = Colors.black12);
    canvas.drawRect(indicator, Paint()..color = indicatorColor);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}