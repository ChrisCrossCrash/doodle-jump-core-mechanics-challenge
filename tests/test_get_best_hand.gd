extends GutTest
## Tests for CardManager.get_best_hand().

# Shorthand for building a Card without the ceremony of CardManager.Card.new(...).
func _c(suit: CardManager.Suit, rank: CardManager.Rank) -> CardManager.Card:
    return CardManager.Card.new(suit, rank)


# ---- Royal Flush ----
func test_royal_flush_hearts():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.ACE),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.KING),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.QUEEN),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.JACK),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TEN),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.ROYAL_FLUSH)


func test_royal_flush_unordered():
    # Royal Flush should be detected regardless of card order.
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.SPADES, CardManager.Rank.TEN),
        _c(CardManager.Suit.SPADES, CardManager.Rank.JACK),
        _c(CardManager.Suit.SPADES, CardManager.Rank.QUEEN),
        _c(CardManager.Suit.SPADES, CardManager.Rank.KING),
        _c(CardManager.Suit.SPADES, CardManager.Rank.ACE),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.ROYAL_FLUSH)


# ---- Straight Flush ----
func test_straight_flush_nine_high():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.CLUBS, CardManager.Rank.NINE),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.EIGHT),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.SIX),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.FIVE),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.STRAIGHT_FLUSH)


func test_straight_flush_wheel():
    # Ace plays low: A-2-3-4-5
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.ACE),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.TWO),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.THREE),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.FOUR),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.FIVE),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.STRAIGHT_FLUSH)


# ---- Four of a Kind ----
func test_four_of_a_kind_sevens():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.SPADES, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TWO),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.FOUR_OF_A_KIND)


func test_four_of_a_kind_aces():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.ACE),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.ACE),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.ACE),
        _c(CardManager.Suit.SPADES, CardManager.Rank.ACE),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.KING),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.FOUR_OF_A_KIND)


# ---- Full House ----
func test_full_house_jacks_over_fours():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.JACK),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.JACK),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.JACK),
        _c(CardManager.Suit.SPADES, CardManager.Rank.FOUR),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.FOUR),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.FULL_HOUSE)


func test_full_house_aces_over_twos():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TWO),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.TWO),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.ACE),
        _c(CardManager.Suit.SPADES, CardManager.Rank.ACE),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.ACE),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.FULL_HOUSE)


# ---- Flush ----
func test_flush_ace_high():
    # Ace-high flush, not a straight.
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.ACE),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TEN),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.FOUR),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TWO),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.FLUSH)


func test_flush_king_high():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.SPADES, CardManager.Rank.KING),
        _c(CardManager.Suit.SPADES, CardManager.Rank.JACK),
        _c(CardManager.Suit.SPADES, CardManager.Rank.NINE),
        _c(CardManager.Suit.SPADES, CardManager.Rank.FIVE),
        _c(CardManager.Suit.SPADES, CardManager.Rank.THREE),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.FLUSH)


# ---- Straight ----
func test_straight_mixed_suits():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.NINE),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.EIGHT),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.SPADES, CardManager.Rank.SIX),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.FIVE),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.STRAIGHT)


func test_straight_wheel():
    # Ace plays low.
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.ACE),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.TWO),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.THREE),
        _c(CardManager.Suit.SPADES, CardManager.Rank.FOUR),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.FIVE),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.STRAIGHT)


func test_straight_broadway_mixed_suits():
    # Broadway in mixed suits is a Straight, NOT a Royal Flush.
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TEN),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.JACK),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.QUEEN),
        _c(CardManager.Suit.SPADES, CardManager.Rank.KING),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.ACE),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.STRAIGHT)


func test_wraparound_is_not_a_straight():
    # Q-K-A-2-3 is NOT a legal straight.
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.QUEEN),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.KING),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.ACE),
        _c(CardManager.Suit.SPADES, CardManager.Rank.TWO),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.THREE),
    ]
    assert_ne(CardManager.get_best_hand(hand), CardManager.HandType.STRAIGHT)


# ---- Three of a Kind ----
func test_three_of_a_kind():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.FIVE),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.FIVE),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.FIVE),
        _c(CardManager.Suit.SPADES, CardManager.Rank.KING),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TWO),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.THREE_OF_A_KIND)


# ---- Two Pair ----
func test_two_pair():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.KING),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.KING),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.THREE),
        _c(CardManager.Suit.SPADES, CardManager.Rank.THREE),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.SEVEN),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.TWO_PAIR)


# ---- One Pair ----
func test_one_pair():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TEN),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.TEN),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.KING),
        _c(CardManager.Suit.SPADES, CardManager.Rank.FOUR),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TWO),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.ONE_PAIR)


# ---- High Card ----
func test_high_card():
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.ACE),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.TEN),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.EIGHT),
        _c(CardManager.Suit.SPADES, CardManager.Rank.SIX),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TWO),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.HIGH_CARD)


func test_almost_a_straight_is_high_card():
    # Gap between 9 and Jack.
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TWO),
        _c(CardManager.Suit.DIAMONDS, CardManager.Rank.FIVE),
        _c(CardManager.Suit.CLUBS, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.SPADES, CardManager.Rank.NINE),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.JACK),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.HIGH_CARD)


func test_four_to_a_flush_is_high_card():
    # Four hearts + one spade is NOT a flush.
    var hand: Array[CardManager.Card] = [
        _c(CardManager.Suit.HEARTS, CardManager.Rank.ACE),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.TEN),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.SEVEN),
        _c(CardManager.Suit.HEARTS, CardManager.Rank.FOUR),
        _c(CardManager.Suit.SPADES, CardManager.Rank.TWO),
    ]
    assert_eq(CardManager.get_best_hand(hand), CardManager.HandType.HIGH_CARD)
