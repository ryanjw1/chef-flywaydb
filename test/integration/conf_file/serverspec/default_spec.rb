require 'serverspec_helper'

describe 'flyway::migrate' do
  if os[:family] == 'windows'
    describe file('C:/flyway-4.0/flyway.cmd') do
      it { should be_file }
      it { should be_owned_by 'flyway' }
    end

    describe command('type C:/flyway-4.0/conf/flyway_test.conf') do
      its(:stdout) { should match(%r{flyway.url=jdbc:mysql://localhost/mysql}) }
      its(:stdout) { should match(/flyway.schemas=flywaydb_test/) }
      its(:stdout) { should match(%r{flyway.locations=filesystem:/tmp/db}) }
    end
  else
    describe file('/opt/flyway/flyway.cmd') do
      it { should be_file }
      it { should be_owned_by 'flyway' }
    end

    describe command('cat /opt/flyway/conf/flyway.conf') do
      its(:stdout) { should match(%r{flyway.url=jdbc:mysql://localhost/mysql}) }
      its(:stdout) { should match(/flyway.schemas=flywaydb_test/) }
      its(:stdout) { should match(%r{flyway.locations=filesystem:/tmp/db}) }
    end
  end
end
