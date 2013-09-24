class OnePageCheckout::AddressBook::NewAddressWidget < Apotomo::Widget
  responds_to_event :reveal_form
  responds_to_event :create_address

  def form(options)
    assign_user(options)
    assign_form

    render
  end

  def call_to_action(options = {})
    assign_user(options)

    render
  end

  def create_address(event)
    assign_user(event.data)

    if create_address_service.call(event.data.fetch(:address))
      trigger :address_created, user: @user
    else
      replace state: :form
    end
  end

  def reveal_form(event)
    replace({ state: :form }, event.data)
  end

  private

  def address_form_factory
    Forms::AddressForm
  end

  def address_form
    @_address_form = address_form_factory.new(Spree::Address.new)
  end

  def assign_form
    @form = address_form
  end

  def assign_user(options)
    @user = Spree::User.find(options.fetch(:user))
  end

  def create_address_service
    @_create_address_service = CreateAddressFactory.build(address_form)
  end
end
