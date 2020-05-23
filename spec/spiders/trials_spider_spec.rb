# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrialsSpider do
  subject { described_class }

  describe '#process' do
    context 'when the domain is wrong' do
      it 'responds with error message' do
        expect(subject.process('wrongdomain.com')).to eq({ error: 'Domain not supported' })
      end
    end
  end

  describe '#parse' do
    context 'when all the content are found' do
      let(:url) { 'https://www.poderjudicialvirtual.com/mn-banco-santander-mexico-s-a--banco-santander-mexico' }
      let(:result) do
        { title: 'Banco Santander México S.a. | Mexico Exp: 1794/2013',
          court: 'Morelia > Juzgado Segundo Civil',
          actor: 'Actor: Banco Santander México S.a.',
          defendant: 'Demandado: Banco Santander Mexico',
          expedient: 'RESUMEN: El Expediente 1794/2013',
          summary: 'fue promovido por BANCO SANTANDER MÉXICO S.A. en contra de BANCO SANTANDER MEXICO en el Juzgado Segundo Civil en Morelia, Michoacán. El Proceso inició el 09 de Enero del 2014 y cuenta con',
          notifications: [{ date: '25 de Abril del 2014',
                            content: 'Por recibido el oficio que remite el Secretario del Tribunal Colegiado en Materia Civil del XI Circuito en el Estado, mediante el cual envía copia certificada de la resolución de fecha 25 de marzo de este año en el que se niega el amparo a la moral quejosa. Asimismo, se tienen por recibidos los autos originales del expediente 750/2011 NOTIFIQUESE PERSONALMENTE.' },
                          { date: '13 de Febrero del 2014',
                            content: 'Por recibido el Oficio anterior que remite la Actuaria del Tribunal Colegiado en Materia Civil del XI Circuito en el Estado, el Titular de este Juzgado queda enterado de su contenido y ordena agregarlo a sus antecedentes.' },
                          { date: '09 de Enero del 2014',
                            content: 'Por recibido el Oficio anterior que remite la Actuaria del Tribunal Colegiado en Materia Civil del XI Circuito en el Estado, el Titular de este Juzgado queda enterado de su contenido y ordena agregarlo a sus antecedentes.' }] }
      end

      it 'creates a new trial' do
        expect { subject.save_trial(result) }.to change { Trial.count }.by(1)
        expect(Trial.last.title).to include(result[:title])
      end

      it 'creates its notifications' do
        expect { subject.save_trial(result) }.to change { Notification.count }.by(3)
      end
    end

    context 'when not all the content are found' do
      let(:incomplete_result) do
        { title: 'Banco Santander México S.a. | Mexico Exp: 1794/2013',
          court: 'Morelia > Juzgado Segundo Civil',
          actor: '',
          defendant: 'Demandado: Banco Santander Mexico',
          expedient: 'RESUMEN: El Expediente 1794/2013',
          summary: 'fue promovido por BANCO SANTANDER MÉXICO S.A. en contra de BANCO SANTANDER MEXICO en el Juzgado Segundo Civil en Morelia, Michoacán. El Proceso inició el 09 de Enero del 2014 y cuenta con',
          notifications: [{ date: '25 de Abril del 2014',
                            content: 'Por recibido el oficio que remite el Secretario del Tribunal Colegiado en Materia Civil del XI Circuito en el Estado, mediante el cual envía copia certificada de la resolución de fecha 25 de marzo de este año en el que se niega el amparo a la moral quejosa. Asimismo, se tienen por recibidos los autos originales del expediente 750/2011 NOTIFIQUESE PERSONALMENTE.' },
                          { date: '13 de Febrero del 2014',
                            content: 'Por recibido el Oficio anterior que remite la Actuaria del Tribunal Colegiado en Materia Civil del XI Circuito en el Estado, el Titular de este Juzgado queda enterado de su contenido y ordena agregarlo a sus antecedentes.' },
                          { date: '09 de Enero del 2014',
                            content: 'Por recibido el Oficio anterior que remite la Actuaria del Tribunal Colegiado en Materia Civil del XI Circuito en el Estado, el Titular de este Juzgado queda enterado de su contenido y ordena agregarlo a sus antecedentes.' }] }
      end
      it 'creates a new trial with missing elements' do
        expect { subject.save_trial(incomplete_result) }.to change { Trial.count }.by(1)
        expect(Trial.last.actor).to eq('')
      end
    end

    context 'when no content found at all' do
      let(:empty_result) do
        { title: '',
          court: '',
          actor: '',
          defendant: '',
          expedient: '',
          summary: '',
          notifications: [] }
      end
      it 'do not create a trial' do
        expect { subject.save_trial(empty_result) }.to change { Trial.count }.by(0)
      end
    end
  end
end
