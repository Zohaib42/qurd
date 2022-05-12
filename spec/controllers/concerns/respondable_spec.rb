require 'rails_helper'

class RespondableController < ApplicationController
  include Respondable
end

describe RespondableController, type: :controller do
  it 'renders not found' do
    expect(controller).to receive(:render).with(status: :not_found, json: { errors: { base: 'Oops! Record not found' } })
    controller.render_not_found
  end

  it 'renders no content' do
    expect(controller).to receive(:render).with(status: :no_content, json: {})
    controller.render_no_content
  end

  it 'renders okay' do
    expect(controller).to receive(:render).with(status: :ok, json: {})
    controller.render_okay
  end

  it 'renders created' do
    expect(controller).to receive(:render).with(status: :created, json: {})
    controller.render_created
  end

  it 'renders unauthorized' do
    expect(controller).to receive(:render).with(status: :unauthorized, json: {})
    controller.render_unauthorized
  end
end
