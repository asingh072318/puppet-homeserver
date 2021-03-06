# frozen_string_literal: true

require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  let(:virtualenv_old_version_output) do
    <<~EOS
      12.0.7
    EOS
  end

  let(:virtualenv_new_version_output) do
    <<~EOS
      virtualenv 20.0.17 from /opt/python/lib/python3.5/site-packages/virtualenv/__init__.py
    EOS
  end

  describe 'virtualenv_version old' do
    context 'returns virtualenv version when virtualenv present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('virtualenv').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('virtualenv --version 2>&1').and_return(virtualenv_old_version_output)
        expect(Facter.value(:virtualenv_version)).to eq('12.0.7')
      end
    end

    context 'returns nil when virtualenv not present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('virtualenv').and_return(false)
        expect(Facter.value(:virtualenv_version)).to eq(nil)
      end
    end
  end

  describe 'virtualenv_version new' do
    context 'returns virtualenv version when virtualenv present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('virtualenv').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('virtualenv --version 2>&1').and_return(virtualenv_new_version_output)
        expect(Facter.value(:virtualenv_version)).to eq('20.0.17')
      end
    end
  end
end
