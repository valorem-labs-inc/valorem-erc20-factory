Feature: ERC20 Token Adapter

    Given an option type exists in the Valorem Core
    When the user wants to adapt the options and claims from that type into ERC20 tokens
    Then the user can adapt the options and claims into ERC20 through the adapter
    And the the users can hold the adapted ERC20 tokens
    And the user can exercise the adapted option tokens during the exercise window
    And the user can wrap/unwrap adapted option tokens any time before expiry
    And the user can redeem adapted claim tokens at or after expiry

    # Token Factory

    Scenario: User deploys new fungible long and short ERC20 tokens corresponding to an option type

    Scenario: User writes options of an option type and gets back long and short ERC20 tokens

    Scenario: User gets the addresses of the long and short tokens for an existing option type

    # ERC20 Long Token

    Scenario: User wraps ERC1155 option token into ERC20 long token for that option type

    Scenario: User unwraps ERC1155 option token from ERC20 long token for that option type

    Scenario: User exercises wrapped option token

    Scenario: User checks underlying position details for long position

    @Revert
    Scenario: User unwraps Option token when at or after expiry timestamp

    @Revert
    Scenario: User wraps Option token when at or after expiry timestamp

    @Revert
    Scenario: User exercises wrapped Option token when before exercise timestamp

    @Revert
    Scenario: User exercises wrapped Option token when at or after expiry timestamp

    @Revert
    Scenario: User holds inadequate long tokens to exercise

    # ERC20 Short token

    Scenario: User redeems underlying/exercise assets from short position after expiry

    Scenario: User checks underlying position details for fungible short position

    @Revert
    Scenario: User redeems before expiry

    @Revert
    Scenario: User holds inadequate short tokens to redeem
