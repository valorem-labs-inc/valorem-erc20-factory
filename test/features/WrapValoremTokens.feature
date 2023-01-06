Feature: Wrap and unwrap Valorem Core tokens

    As a Valorem User,
    I want to wrap and unwrap Valorem Core 1155 tokens into ERC20 tokens,
    so that I can transact using them within the broader DeFi ecosystem.

    # Options

    Scenario: User wraps Option token

    Scenario: User unwraps Option token

    Scenario: User exercises Wrapped Option token

    Scenario: User checks information / position of Valorem Core token for Wrapped Option token

    @Revert
    Scenario: User wraps Option token when insufficient ERC20 approval on exercise asset

    @Revert
    Scenario: User wraps Option token when before exercise period

    @Revert
    Scenario: User wraps Option token when after exercise period

    @Revert
    Scenario: User unwraps Option token when before exercise period

    Scenario: User unwraps Option token when after exercise period

    # Claims

    Scenario: User wraps Claim token

    Scenario: User unwraps Claim token

    Scenario: User redeems Wrapped Claim token

    Scenario: User checks information / position of Valore Core token for Wrapped Claim token

    @Revert
    Scenario: User wraps Claim token when before redemption period

    Scenario: User unwraps Claim token when before redemption period
