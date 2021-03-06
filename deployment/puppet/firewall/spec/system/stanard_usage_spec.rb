require 'spec_helper_system'

# Some tests for the standard recommended usage
describe "standard usage:" do
  let(:pp) do
    pp = <<-EOS
class my_fw::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto   => 'icmp',
    action  => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }
}
class my_fw::post {
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}
resources { "firewall":
  purge => true
}
Firewall {
  before  => Class['my_fw::post'],
  require => Class['my_fw::pre'],
}
class { ['my_fw::pre', 'my_fw::post']: }
class { 'firewall': }
firewall { '500 open up port 22':
  action => 'accept',
  proto => 'tcp',
  dport => 22,
}
    EOS
  end

  it 'make sure it runs without error' do
    puppet_apply(pp) do |r|
      r[:stderr].should == ''
      r[:exit_code].should_not eq(1)
    end
  end

  it 'should be idempotent' do
    puppet_apply(pp) do |r|
      r[:stderr].should == ''
      r[:exit_code].should == 0
    end
  end
end
