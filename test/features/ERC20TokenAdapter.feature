Feature: ERC20 Token Adapter

    As a Valorem User,
    I want to use Valorem Core options and claims as long and short ERC20 tokens,
    so that I can transact within the broader DeFi ecosystem which widely supports ERC20.

    Background: Option Type Setup
        Given an Option Type exists in the Valorem Core
        And ERC20 Long and Short Adapter contracts are deployed

    # ERC20 Router / Gateway

    @SkipBackground
    Scenario: Deploy ERC20 Long and Short Adapter contracts for a given Option Type

    @Revert
    Scenario: Deploy ERC20 Long and Short Adapter contracts for a given Option Type when already deployed

    Scenario: Write new ERC20 Long and Short positions

    @Revert
    Scenario: Write new ERC20 Long and Short positions when at expiry timestamp

    @Revert
    Scenario: Write new ERC20 Long and Short positions when after expiry timestamp

    Scenario: Get addresses of the ERC20 Long and Short tokens for a given Option Type

    Scenario: Wrap ERC1155 Options into ERC20 Longs

    @Revert
    Scenario: Wrap ERC1155 Options when at or after expiry timestamp

    Scenario: Unwrap ERC20 Longs into ERC1155 Options

    @Revert
    Scenario: Unwrap ERC20 Longs when at or after expiry timestamp

    # ERC20 Long token

    Scenario: Check position of ERC20 Longs

    Scenario: Exercise ERC20 Longs for ERC20 Underlying asset

    @Revert
    Scenario: Exercise ERC20 Longs when before exercise timestamp

    @Revert
    Scenario: Exercise ERC20 Longs when at or after expiry timestamp

    @Revert
    Scenario: Exercise ERC20 Longs when user holds insufficient ERC20 Exercise asset

    # ERC20 Short token

    Scenario: Check position of ERC20 Shorts

    Scenario: Redeem ERC20 Shorts for ERC20 Underlying asset / ERC20 Exercise asset

    @Revert
    Scenario: Redeem ERC20 Shorts when before expiry timestamp
