# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrialsController, type: :controller do
  context '#scrape' do
    subject { post(:scrape, params: { url: url }) }
    let(:good_response) do
      {
        spider_name: 'trial_spider',
        status: :completed,
        error: nil,
        environment: 'development',
        start_time: '2020-05-22 17:05:31.397545 -0500',
        stop_time: '2020-05-22 17:05:32.186736 -0500',
        running_time: 0.789,
        visits: { requests: 1, responses: 1 },
        items: { sent: 0, processed: 0 },
        events: { requests_errors: {}, drop_items_errors: {}, custom: {} }
      }
    end

    let(:error_response) do
      {
        spider_name: 'trial_spider',
        status: :error,
        error: 'Error message',
        environment: 'development',
        start_time: '2020-05-22 17:05:31.397545 -0500',
        stop_time: '2020-05-22 17:05:32.186736 -0500',
        running_time: 0.789,
        visits: { requests: 1, responses: 1 },
        items: { sent: 0, processed: 0 },
        events: { requests_errors: {}, drop_items_errors: {}, custom: {} }
      }
    end

    let(:url) { 'https://www.poderjudicialvirtual.com/mn-banco-santander-mexico-s-a--banco-santander-mexico' }

    context 'when the scrap is correct' do
      it 'redirects to trials page' do
        allow(TrialsSpider).to receive(:process).and_return(good_response)
        expect(subject).to redirect_to('/trials')
      end

      it 'flashes success message' do
        allow(TrialsSpider).to receive(:process).and_return(good_response)
        expect(subject.request.flash[:notice]).to eq('New Trial Added!!')
      end
    end

    context 'when the scrap not correct' do
      it 'redirects to trials page' do
        allow(TrialsSpider).to receive(:process).and_return(error_response)
        expect(subject).to redirect_to('/trials')
      end

      it 'flashes error message' do
        allow(TrialsSpider).to receive(:process).and_return(error_response)
        expect(subject.request.flash[:alert]).to eq('Error message')
      end
    end
  end
end
