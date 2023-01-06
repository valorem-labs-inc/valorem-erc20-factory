Feature: Adapt Valorem Core Tokens to the ERC20 standard with fungible long and short positions

    As a Valorem User,
    I want to adapt Valorem Core 1155 options and claims into long and
    short fungible ERC20 tokens, so that I can transact using them within the
    DeFi ecosystem components supporting ERC20 tokens.

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
