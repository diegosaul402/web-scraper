# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trial, type: :model do
  describe '#save' do
    context 'when a new trial is saved' do
      before(:all) do
        result =
          { title: 'Banco Santander México S.a. | Mexico Exp: 1794/2013',
            court: 'Morelia > Juzgado Segundo Civil',
            actor: 'Actor: Banco Santander México S.a.',
            defendant: 'Demandado: Banco Santander Mexico',
            expedient: 'RESUMEN: El Expediente 1794/2013',
            summary: 'fue promovido por BANCO SANTANDER MÉXICO S.A. en contra de BANCO SANTANDER MEXICO en el Juzgado Segundo Civil en Morelia, Michoacán. El Proceso inició el 09 de Enero del 2014 y cuenta con' }
        Trial.create(result)
      end

      it 'removes unwanted text on actor field' do
        expect(Trial.last.actor). to eq('Banco Santander México S.a.')
      end

      it 'removes unwanted text on defendant field' do
        expect(Trial.last.defendant). to eq('Banco Santander Mexico')
      end

      it 'saves only expedient number' do
        expect(Trial.last.expedient). to eq('1794/2013')
      end
    end
  end
end
