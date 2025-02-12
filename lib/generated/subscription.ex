defmodule Stripe.Subscription do
  use Stripe.Entity

  @moduledoc "Subscriptions allow you to charge a customer on a recurring basis.\n\nRelated guide: [Creating subscriptions](https://stripe.com/docs/billing/subscriptions/creating)"
  (
    defstruct [
      :default_tax_rates,
      :pending_update,
      :id,
      :transfer_data,
      :items,
      :status,
      :current_period_start,
      :trial_start,
      :trial_settings,
      :cancel_at,
      :trial_end,
      :created,
      :currency,
      :latest_invoice,
      :current_period_end,
      :canceled_at,
      :schedule,
      :automatic_tax,
      :test_clock,
      :billing_cycle_anchor,
      :object,
      :cancel_at_period_end,
      :default_source,
      :next_pending_invoice_item_invoice,
      :billing_thresholds,
      :pending_invoice_item_interval,
      :application,
      :payment_settings,
      :days_until_due,
      :ended_at,
      :customer,
      :pause_collection,
      :on_behalf_of,
      :start_date,
      :discount,
      :pending_setup_intent,
      :cancellation_details,
      :description,
      :metadata,
      :default_payment_method,
      :collection_method,
      :livemode,
      :application_fee_percent
    ]

    @typedoc "The `subscription` type.\n\n  * `application` ID of the Connect Application that created the subscription.\n  * `application_fee_percent` A non-negative decimal between 0 and 100, with at most two decimal places. This represents the percentage of the subscription invoice total that will be transferred to the application owner's Stripe account.\n  * `automatic_tax` \n  * `billing_cycle_anchor` Determines the date of the first full invoice, and, for plans with `month` or `year` intervals, the day of the month for subsequent invoices. The timestamp is in UTC format.\n  * `billing_thresholds` Define thresholds at which an invoice will be sent, and the subscription advanced to a new billing period\n  * `cancel_at` A date in the future at which the subscription will automatically get canceled\n  * `cancel_at_period_end` If the subscription has been canceled with the `at_period_end` flag set to `true`, `cancel_at_period_end` on the subscription will be true. You can use this attribute to determine whether a subscription that has a status of active is scheduled to be canceled at the end of the current period.\n  * `canceled_at` If the subscription has been canceled, the date of that cancellation. If the subscription was canceled with `cancel_at_period_end`, `canceled_at` will reflect the time of the most recent update request, not the end of the subscription period when the subscription is automatically moved to a canceled state.\n  * `cancellation_details` Details about why this subscription was cancelled\n  * `collection_method` Either `charge_automatically`, or `send_invoice`. When charging automatically, Stripe will attempt to pay this subscription at the end of the cycle using the default source attached to the customer. When sending an invoice, Stripe will email your customer an invoice with payment instructions and mark the subscription as `active`.\n  * `created` Time at which the object was created. Measured in seconds since the Unix epoch.\n  * `currency` Three-letter [ISO currency code](https://www.iso.org/iso-4217-currency-codes.html), in lowercase. Must be a [supported currency](https://stripe.com/docs/currencies).\n  * `current_period_end` End of the current period that the subscription has been invoiced for. At the end of this period, a new invoice will be created.\n  * `current_period_start` Start of the current period that the subscription has been invoiced for.\n  * `customer` ID of the customer who owns the subscription.\n  * `days_until_due` Number of days a customer has to pay invoices generated by this subscription. This value will be `null` for subscriptions where `collection_method=charge_automatically`.\n  * `default_payment_method` ID of the default payment method for the subscription. It must belong to the customer associated with the subscription. This takes precedence over `default_source`. If neither are set, invoices will use the customer's [invoice_settings.default_payment_method](https://stripe.com/docs/api/customers/object#customer_object-invoice_settings-default_payment_method) or [default_source](https://stripe.com/docs/api/customers/object#customer_object-default_source).\n  * `default_source` ID of the default payment source for the subscription. It must belong to the customer associated with the subscription and be in a chargeable state. If `default_payment_method` is also set, `default_payment_method` will take precedence. If neither are set, invoices will use the customer's [invoice_settings.default_payment_method](https://stripe.com/docs/api/customers/object#customer_object-invoice_settings-default_payment_method) or [default_source](https://stripe.com/docs/api/customers/object#customer_object-default_source).\n  * `default_tax_rates` The tax rates that will apply to any subscription item that does not have `tax_rates` set. Invoices created will have their `default_tax_rates` populated from the subscription.\n  * `description` The subscription's description, meant to be displayable to the customer. Use this field to optionally store an explanation of the subscription for rendering in Stripe surfaces.\n  * `discount` Describes the current discount applied to this subscription, if there is one. When billing, a discount applied to a subscription overrides a discount applied on a customer-wide basis.\n  * `ended_at` If the subscription has ended, the date the subscription ended.\n  * `id` Unique identifier for the object.\n  * `items` List of subscription items, each with an attached price.\n  * `latest_invoice` The most recent invoice this subscription has generated.\n  * `livemode` Has the value `true` if the object exists in live mode or the value `false` if the object exists in test mode.\n  * `metadata` Set of [key-value pairs](https://stripe.com/docs/api/metadata) that you can attach to an object. This can be useful for storing additional information about the object in a structured format.\n  * `next_pending_invoice_item_invoice` Specifies the approximate timestamp on which any pending invoice items will be billed according to the schedule provided at `pending_invoice_item_interval`.\n  * `object` String representing the object's type. Objects of the same type share the same value.\n  * `on_behalf_of` The account (if any) the charge was made on behalf of for charges associated with this subscription. See the Connect documentation for details.\n  * `pause_collection` If specified, payment collection for this subscription will be paused.\n  * `payment_settings` Payment settings passed on to invoices created by the subscription.\n  * `pending_invoice_item_interval` Specifies an interval for how often to bill for any pending invoice items. It is analogous to calling [Create an invoice](https://stripe.com/docs/api#create_invoice) for the given subscription at the specified interval.\n  * `pending_setup_intent` You can use this [SetupIntent](https://stripe.com/docs/api/setup_intents) to collect user authentication when creating a subscription without immediate payment or updating a subscription's payment method, allowing you to optimize for off-session payments. Learn more in the [SCA Migration Guide](https://stripe.com/docs/billing/migration/strong-customer-authentication#scenario-2).\n  * `pending_update` If specified, [pending updates](https://stripe.com/docs/billing/subscriptions/pending-updates) that will be applied to the subscription once the `latest_invoice` has been paid.\n  * `schedule` The schedule attached to the subscription\n  * `start_date` Date when the subscription was first created. The date might differ from the `created` date due to backdating.\n  * `status` Possible values are `incomplete`, `incomplete_expired`, `trialing`, `active`, `past_due`, `canceled`, or `unpaid`. \n\nFor `collection_method=charge_automatically` a subscription moves into `incomplete` if the initial payment attempt fails. A subscription in this state can only have metadata and default_source updated. Once the first invoice is paid, the subscription moves into an `active` state. If the first invoice is not paid within 23 hours, the subscription transitions to `incomplete_expired`. This is a terminal state, the open invoice will be voided and no further invoices will be generated. \n\nA subscription that is currently in a trial period is `trialing` and moves to `active` when the trial period is over. \n\nIf subscription `collection_method=charge_automatically`, it becomes `past_due` when payment is required but cannot be paid (due to failed payment or awaiting additional user actions). Once Stripe has exhausted all payment retry attempts, the subscription will become `canceled` or `unpaid` (depending on your subscriptions settings). \n\nIf subscription `collection_method=send_invoice` it becomes `past_due` when its invoice is not paid by the due date, and `canceled` or `unpaid` if it is still not paid by an additional deadline after that. Note that when a subscription has a status of `unpaid`, no subsequent invoices will be attempted (invoices will be created, but then immediately automatically closed). After receiving updated payment information from a customer, you may choose to reopen and pay their closed invoices.\n  * `test_clock` ID of the test clock this subscription belongs to.\n  * `transfer_data` The account (if any) the subscription's payments will be attributed to for tax reporting, and where funds from each payment will be transferred to for each of the subscription's invoices.\n  * `trial_end` If the subscription has a trial, the end of that trial.\n  * `trial_settings` Settings related to subscription trials.\n  * `trial_start` If the subscription has a trial, the beginning of that trial.\n"
    @type t :: %__MODULE__{
            application: (binary | term | term) | nil,
            application_fee_percent: term | nil,
            automatic_tax: term,
            billing_cycle_anchor: integer,
            billing_thresholds: term | nil,
            cancel_at: integer | nil,
            cancel_at_period_end: boolean,
            canceled_at: integer | nil,
            cancellation_details: term | nil,
            collection_method: binary,
            created: integer,
            currency: binary,
            current_period_end: integer,
            current_period_start: integer,
            customer: binary | Stripe.Customer.t() | Stripe.DeletedCustomer.t(),
            days_until_due: integer | nil,
            default_payment_method: (binary | Stripe.PaymentMethod.t()) | nil,
            default_source: (binary | Stripe.PaymentSource.t()) | nil,
            default_tax_rates: term | nil,
            description: binary | nil,
            discount: term | nil,
            ended_at: integer | nil,
            id: binary,
            items: term,
            latest_invoice: (binary | Stripe.Invoice.t()) | nil,
            livemode: boolean,
            metadata: term,
            next_pending_invoice_item_invoice: integer | nil,
            object: binary,
            on_behalf_of: (binary | Stripe.Account.t()) | nil,
            pause_collection: term | nil,
            payment_settings: term | nil,
            pending_invoice_item_interval: term | nil,
            pending_setup_intent: (binary | Stripe.SetupIntent.t()) | nil,
            pending_update: term | nil,
            schedule: (binary | Stripe.SubscriptionSchedule.t()) | nil,
            start_date: integer,
            status: binary,
            test_clock: (binary | Stripe.TestHelpers.TestClock.t()) | nil,
            transfer_data: term | nil,
            trial_end: integer | nil,
            trial_settings: term | nil,
            trial_start: integer | nil
          }
  )

  (
    @typedoc nil
    @type acss_debit :: %{
            optional(:mandate_options) => mandate_options,
            optional(:verification_method) => :automatic | :instant | :microdeposits
          }
  )

  (
    @typedoc nil
    @type add_invoice_items :: %{
            optional(:price) => binary,
            optional(:price_data) => price_data,
            optional(:quantity) => integer,
            optional(:tax_rates) => list(binary) | binary
          }
  )

  (
    @typedoc nil
    @type automatic_tax :: %{optional(:enabled) => boolean}
  )

  (
    @typedoc nil
    @type bancontact :: %{optional(:preferred_language) => :de | :en | :fr | :nl}
  )

  (
    @typedoc "Configuration for the bank transfer funding type, if the `funding_type` is set to `bank_transfer`."
    @type bank_transfer :: %{
            optional(:eu_bank_transfer) => eu_bank_transfer,
            optional(:type) => binary
          }
  )

  (
    @typedoc nil
    @type billing_thresholds :: %{
            optional(:amount_gte) => integer,
            optional(:reset_billing_cycle_anchor) => boolean
          }
  )

  (
    @typedoc "Details about why this subscription was cancelled"
    @type cancellation_details :: %{
            optional(:comment) => binary | binary,
            optional(:feedback) =>
              :customer_service
              | :low_quality
              | :missing_features
              | :other
              | :switched_service
              | :too_complex
              | :too_expensive
              | :unused
          }
  )

  (
    @typedoc nil
    @type card :: %{
            optional(:mandate_options) => mandate_options,
            optional(:network) =>
              :amex
              | :cartes_bancaires
              | :diners
              | :discover
              | :eftpos_au
              | :interac
              | :jcb
              | :mastercard
              | :unionpay
              | :unknown
              | :visa,
            optional(:request_three_d_secure) => :any | :automatic
          }
  )

  (
    @typedoc nil
    @type created :: %{
            optional(:gt) => integer,
            optional(:gte) => integer,
            optional(:lt) => integer,
            optional(:lte) => integer
          }
  )

  (
    @typedoc nil
    @type current_period_end :: %{
            optional(:gt) => integer,
            optional(:gte) => integer,
            optional(:lt) => integer,
            optional(:lte) => integer
          }
  )

  (
    @typedoc nil
    @type current_period_start :: %{
            optional(:gt) => integer,
            optional(:gte) => integer,
            optional(:lt) => integer,
            optional(:lte) => integer
          }
  )

  (
    @typedoc nil
    @type customer_balance :: %{
            optional(:bank_transfer) => bank_transfer,
            optional(:funding_type) => binary
          }
  )

  (
    @typedoc "Defines how the subscription should behave when the user's free trial ends."
    @type end_behavior :: %{
            optional(:missing_payment_method) => :cancel | :create_invoice | :pause
          }
  )

  (
    @typedoc "Configuration for eu_bank_transfer funding type."
    @type eu_bank_transfer :: %{optional(:country) => binary}
  )

  (
    @typedoc "Additional fields for Financial Connections Session creation"
    @type financial_connections :: %{
            optional(:permissions) =>
              list(:balances | :ownership | :payment_method | :transactions)
          }
  )

  (
    @typedoc nil
    @type items :: %{
            optional(:billing_thresholds) => billing_thresholds | binary,
            optional(:metadata) => %{optional(binary) => binary},
            optional(:plan) => binary,
            optional(:price) => binary,
            optional(:price_data) => price_data,
            optional(:quantity) => integer,
            optional(:tax_rates) => list(binary) | binary
          }
  )

  (
    @typedoc "Additional fields for Mandate creation"
    @type mandate_options :: %{optional(:transaction_type) => :business | :personal}
  )

  (
    @typedoc nil
    @type pause_collection :: %{
            optional(:behavior) => :keep_as_draft | :mark_uncollectible | :void,
            optional(:resumes_at) => integer
          }
  )

  (
    @typedoc "Payment-method-specific configuration to provide to invoices created by the subscription."
    @type payment_method_options :: %{
            optional(:acss_debit) => acss_debit | binary,
            optional(:bancontact) => bancontact | binary,
            optional(:card) => card | binary,
            optional(:customer_balance) => customer_balance | binary,
            optional(:konbini) => map() | binary,
            optional(:us_bank_account) => us_bank_account | binary
          }
  )

  (
    @typedoc "Payment settings to pass to invoices created by the subscription."
    @type payment_settings :: %{
            optional(:payment_method_options) => payment_method_options,
            optional(:payment_method_types) =>
              list(
                :ach_credit_transfer
                | :ach_debit
                | :acss_debit
                | :au_becs_debit
                | :bacs_debit
                | :bancontact
                | :boleto
                | :card
                | :cashapp
                | :customer_balance
                | :fpx
                | :giropay
                | :grabpay
                | :ideal
                | :konbini
                | :link
                | :paynow
                | :paypal
                | :promptpay
                | :sepa_credit_transfer
                | :sepa_debit
                | :sofort
                | :us_bank_account
                | :wechat_pay
              )
              | binary,
            optional(:save_default_payment_method) => :off | :on_subscription
          }
  )

  (
    @typedoc nil
    @type pending_invoice_item_interval :: %{
            optional(:interval) => :day | :month | :week | :year,
            optional(:interval_count) => integer
          }
  )

  (
    @typedoc "Data used to generate a new [Price](https://stripe.com/docs/api/prices) object inline."
    @type price_data :: %{
            optional(:currency) => binary,
            optional(:product) => binary,
            optional(:recurring) => recurring,
            optional(:tax_behavior) => :exclusive | :inclusive | :unspecified,
            optional(:unit_amount) => integer,
            optional(:unit_amount_decimal) => binary
          }
  )

  (
    @typedoc "The recurring components of a price such as `interval` and `interval_count`."
    @type recurring :: %{
            optional(:interval) => :day | :month | :week | :year,
            optional(:interval_count) => integer
          }
  )

  (
    @typedoc "If specified, the funds from the subscription's invoices will be transferred to the destination and the ID of the resulting transfers will be found on the resulting charges."
    @type transfer_data :: %{
            optional(:amount_percent) => number,
            optional(:destination) => binary
          }
  )

  (
    @typedoc "Settings related to subscription trials."
    @type trial_settings :: %{optional(:end_behavior) => end_behavior}
  )

  (
    @typedoc nil
    @type us_bank_account :: %{
            optional(:financial_connections) => financial_connections,
            optional(:verification_method) => :automatic | :instant | :microdeposits
          }
  )

  (
    nil

    @doc "<p>Search for subscriptions you’ve previously created using Stripe’s <a href=\"/docs/search#search-query-language\">Search Query Language</a>.\nDon’t use search in read-after-write flows where strict consistency is necessary. Under normal operating\nconditions, data is searchable in less than a minute. Occasionally, propagation of new or updated data can be up\nto an hour behind during outages. Search functionality is not available to merchants in India.</p>\n\n#### Details\n\n * Method: `get`\n * Path: `/v1/subscriptions/search`\n"
    (
      @spec search(
              params :: %{
                optional(:expand) => list(binary),
                optional(:limit) => integer,
                optional(:page) => binary,
                optional(:query) => binary
              },
              opts :: Keyword.t()
            ) ::
              {:ok, Stripe.SearchResult.t(Stripe.Subscription.t())}
              | {:error, Stripe.ApiErrors.t()}
              | {:error, term()}
      def search(params \\ %{}, opts \\ []) do
        path = Stripe.OpenApi.Path.replace_path_params("/v1/subscriptions/search", [], [])

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:get)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>By default, returns a list of subscriptions that have not been canceled. In order to list canceled subscriptions, specify <code>status=canceled</code>.</p>\n\n#### Details\n\n * Method: `get`\n * Path: `/v1/subscriptions`\n"
    (
      @spec list(
              params :: %{
                optional(:automatic_tax) => automatic_tax,
                optional(:collection_method) => :charge_automatically | :send_invoice,
                optional(:created) => created | integer,
                optional(:current_period_end) => current_period_end | integer,
                optional(:current_period_start) => current_period_start | integer,
                optional(:customer) => binary,
                optional(:ending_before) => binary,
                optional(:expand) => list(binary),
                optional(:limit) => integer,
                optional(:plan) => binary,
                optional(:price) => binary,
                optional(:starting_after) => binary,
                optional(:status) =>
                  :active
                  | :all
                  | :canceled
                  | :ended
                  | :incomplete
                  | :incomplete_expired
                  | :past_due
                  | :paused
                  | :trialing
                  | :unpaid,
                optional(:test_clock) => binary
              },
              opts :: Keyword.t()
            ) ::
              {:ok, Stripe.List.t(Stripe.Subscription.t())}
              | {:error, Stripe.ApiErrors.t()}
              | {:error, term()}
      def list(params \\ %{}, opts \\ []) do
        path = Stripe.OpenApi.Path.replace_path_params("/v1/subscriptions", [], [])

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:get)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Creates a new subscription on an existing customer. Each customer can have up to 500 active or scheduled subscriptions.</p>\n\n<p>When you create a subscription with <code>collection_method=charge_automatically</code>, the first invoice is finalized as part of the request.\nThe <code>payment_behavior</code> parameter determines the exact behavior of the initial payment.</p>\n\n<p>To start subscriptions where the first invoice always begins in a <code>draft</code> status, use <a href=\"/docs/billing/subscriptions/subscription-schedules#managing\">subscription schedules</a> instead.\nSchedules provide the flexibility to model more complex billing configurations that change over time.</p>\n\n#### Details\n\n * Method: `post`\n * Path: `/v1/subscriptions`\n"
    (
      @spec create(
              params :: %{
                optional(:add_invoice_items) => list(add_invoice_items),
                optional(:application_fee_percent) => number,
                optional(:automatic_tax) => automatic_tax,
                optional(:backdate_start_date) => integer,
                optional(:billing_cycle_anchor) => integer,
                optional(:billing_thresholds) => billing_thresholds | binary,
                optional(:cancel_at) => integer,
                optional(:cancel_at_period_end) => boolean,
                optional(:collection_method) => :charge_automatically | :send_invoice,
                optional(:coupon) => binary,
                optional(:currency) => binary,
                optional(:customer) => binary,
                optional(:days_until_due) => integer,
                optional(:default_payment_method) => binary,
                optional(:default_source) => binary,
                optional(:default_tax_rates) => list(binary) | binary,
                optional(:description) => binary,
                optional(:expand) => list(binary),
                optional(:items) => list(items),
                optional(:metadata) => %{optional(binary) => binary} | binary,
                optional(:off_session) => boolean,
                optional(:on_behalf_of) => binary | binary,
                optional(:payment_behavior) =>
                  :allow_incomplete
                  | :default_incomplete
                  | :error_if_incomplete
                  | :pending_if_incomplete,
                optional(:payment_settings) => payment_settings,
                optional(:pending_invoice_item_interval) =>
                  pending_invoice_item_interval | binary,
                optional(:promotion_code) => binary,
                optional(:proration_behavior) => :always_invoice | :create_prorations | :none,
                optional(:transfer_data) => transfer_data,
                optional(:trial_end) => :now | integer,
                optional(:trial_from_plan) => boolean,
                optional(:trial_period_days) => integer,
                optional(:trial_settings) => trial_settings
              },
              opts :: Keyword.t()
            ) ::
              {:ok, Stripe.Subscription.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def create(params \\ %{}, opts \\ []) do
        path = Stripe.OpenApi.Path.replace_path_params("/v1/subscriptions", [], [])

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:post)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Updates an existing subscription on a customer to match the specified parameters. When changing plans or quantities, we will optionally prorate the price we charge next month to make up for any price changes. To preview how the proration will be calculated, use the <a href=\"#upcoming_invoice\">upcoming invoice</a> endpoint.</p>\n\n#### Details\n\n * Method: `post`\n * Path: `/v1/subscriptions/{subscription_exposed_id}`\n"
    (
      @spec update(
              subscription_exposed_id :: binary(),
              params :: %{
                optional(:add_invoice_items) => list(add_invoice_items),
                optional(:application_fee_percent) => number,
                optional(:automatic_tax) => automatic_tax,
                optional(:billing_cycle_anchor) => :now | :unchanged,
                optional(:billing_thresholds) => billing_thresholds | binary,
                optional(:cancel_at) => integer | binary,
                optional(:cancel_at_period_end) => boolean,
                optional(:cancellation_details) => cancellation_details,
                optional(:collection_method) => :charge_automatically | :send_invoice,
                optional(:coupon) => binary,
                optional(:days_until_due) => integer,
                optional(:default_payment_method) => binary,
                optional(:default_source) => binary | binary,
                optional(:default_tax_rates) => list(binary) | binary,
                optional(:description) => binary | binary,
                optional(:expand) => list(binary),
                optional(:items) => list(items),
                optional(:metadata) => %{optional(binary) => binary} | binary,
                optional(:off_session) => boolean,
                optional(:on_behalf_of) => binary | binary,
                optional(:pause_collection) => pause_collection | binary,
                optional(:payment_behavior) =>
                  :allow_incomplete
                  | :default_incomplete
                  | :error_if_incomplete
                  | :pending_if_incomplete,
                optional(:payment_settings) => payment_settings,
                optional(:pending_invoice_item_interval) =>
                  pending_invoice_item_interval | binary,
                optional(:promotion_code) => binary,
                optional(:proration_behavior) => :always_invoice | :create_prorations | :none,
                optional(:proration_date) => integer,
                optional(:transfer_data) => transfer_data | binary,
                optional(:trial_end) => :now | integer,
                optional(:trial_from_plan) => boolean,
                optional(:trial_settings) => trial_settings
              },
              opts :: Keyword.t()
            ) ::
              {:ok, Stripe.Subscription.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def update(subscription_exposed_id, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/subscriptions/{subscription_exposed_id}",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "subscription_exposed_id",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "subscription_exposed_id",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [subscription_exposed_id]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:post)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Retrieves the subscription with the given ID.</p>\n\n#### Details\n\n * Method: `get`\n * Path: `/v1/subscriptions/{subscription_exposed_id}`\n"
    (
      @spec retrieve(
              subscription_exposed_id :: binary(),
              params :: %{optional(:expand) => list(binary)},
              opts :: Keyword.t()
            ) ::
              {:ok, Stripe.Subscription.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def retrieve(subscription_exposed_id, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/subscriptions/{subscription_exposed_id}",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "subscription_exposed_id",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "subscription_exposed_id",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [subscription_exposed_id]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:get)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Cancels a customer’s subscription immediately. The customer will not be charged again for the subscription.</p>\n\n<p>Note, however, that any pending invoice items that you’ve created will still be charged for at the end of the period, unless manually <a href=\"#delete_invoiceitem\">deleted</a>. If you’ve set the subscription to cancel at the end of the period, any pending prorations will also be left in place and collected at the end of the period. But if the subscription is set to cancel immediately, pending prorations will be removed.</p>\n\n<p>By default, upon subscription cancellation, Stripe will stop automatic collection of all finalized invoices for the customer. This is intended to prevent unexpected payment attempts after the customer has canceled a subscription. However, you can resume automatic collection of the invoices manually after subscription cancellation to have us proceed. Or, you could check for unpaid invoices before allowing the customer to cancel the subscription at all.</p>\n\n#### Details\n\n * Method: `delete`\n * Path: `/v1/subscriptions/{subscription_exposed_id}`\n"
    (
      @spec cancel(
              subscription_exposed_id :: binary(),
              params :: %{
                optional(:cancellation_details) => cancellation_details,
                optional(:expand) => list(binary),
                optional(:invoice_now) => boolean,
                optional(:prorate) => boolean
              },
              opts :: Keyword.t()
            ) ::
              {:ok, Stripe.Subscription.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def cancel(subscription_exposed_id, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/subscriptions/{subscription_exposed_id}",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "subscription_exposed_id",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "subscription_exposed_id",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [subscription_exposed_id]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:delete)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Initiates resumption of a paused subscription, optionally resetting the billing cycle anchor and creating prorations. If a resumption invoice is generated, it must be paid or marked uncollectible before the subscription will be unpaused. If payment succeeds the subscription will become <code>active</code>, and if payment fails the subscription will be <code>past_due</code>. The resumption invoice will void automatically if not paid by the expiration date.</p>\n\n#### Details\n\n * Method: `post`\n * Path: `/v1/subscriptions/{subscription}/resume`\n"
    (
      @spec resume(
              subscription :: binary(),
              params :: %{
                optional(:billing_cycle_anchor) => :now | :unchanged,
                optional(:expand) => list(binary),
                optional(:proration_behavior) => :always_invoice | :create_prorations | :none,
                optional(:proration_date) => integer
              },
              opts :: Keyword.t()
            ) ::
              {:ok, Stripe.Subscription.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def resume(subscription, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/subscriptions/{subscription}/resume",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "subscription",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "subscription",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [subscription]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:post)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Removes the currently applied discount on a subscription.</p>\n\n#### Details\n\n * Method: `delete`\n * Path: `/v1/subscriptions/{subscription_exposed_id}/discount`\n"
    (
      @spec delete_discount(subscription_exposed_id :: binary(), opts :: Keyword.t()) ::
              {:ok, Stripe.DeletedDiscount.t()}
              | {:error, Stripe.ApiErrors.t()}
              | {:error, term()}
      def delete_discount(subscription_exposed_id, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/subscriptions/{subscription_exposed_id}/discount",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "subscription_exposed_id",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "subscription_exposed_id",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [subscription_exposed_id]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_method(:delete)
        |> Stripe.Request.make_request()
      end
    )
  )
end
