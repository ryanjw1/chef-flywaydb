require 'serverspec_helper'

describe 'flyway::migrate' do
  if os[:family] == 'windows'
    describe file('C:/flywaydb/flyway/flyway.cmd') do
      it { should be_file }
      it { should be_owned_by 'flyway' }
    end

    describe file('C:/flywaydb/flyway') do
      it { should be_symlink }
      it { should be_owned_by 'flyway' }
    end

    describe file("C:/flywaydb/flyway/drivers/mysql-connector-java-#{MARIADB_VERSION}.jar") do
      it { should be_file }
      it { should be_owned_by 'flyway' }
    end

    describe command('type C:/flywaydb/flyway/conf/flyway.conf') do
      its(:stdout) { should match(/This file was generated by Chef/) }
      its(:stdout) { should_not match(/flyway/) }
    end

    describe command('type C:/flywaydb/flyway/conf/flyway_test.conf') do
      its(:stdout) { should match(/This file was generated by Chef/) }
      its(:stdout) { should match(/flyway.user=root/) }
      its(:stdout) { should match(%r{flyway.url=jdbc:mysql://localhost/mysql/}) }
      its(:stdout) { should match(/flyway.schemas=flywaydb_test/) }
      its(:stdout) { should match(%r{flyway.locations=filesystem:/tmp/db}) }
      its(:stdout) { should match(/flyway.cleanDisabled=true/) }
      its(:stdout) { should match(/flyway.placeholders.test_user=test/) }
    end
  else
    describe file('/opt/flywaydb/flyway/flyway') do
      it { should be_file }
      it { should be_owned_by 'flyway' }
      it { should be_executable }
    end

    describe file('/opt/flywaydb/flyway') do
      it { should be_symlink }
      it { should be_owned_by 'flyway' }
    end

    describe file("/opt/flywaydb/flyway/drivers/mysql-connector-java-#{MARIADB_VERSION}.jar") do
      it { should_not be_file }
      it { should_not be_owned_by 'flyway' }
    end

    describe command('cat /opt/flywaydb/flyway/conf/flyway.conf') do
      its(:stdout) { should match(/This file was generated by Chef/) }
      its(:stdout) { should_not match(/flyway/) }
    end

    describe command('cat /opt/flywaydb/flyway/conf/flyway_test.conf') do
      its(:stdout) { should match(/This file was generated by Chef/) }
      its(:stdout) { should match(/flyway.user=root/) }
      its(:stdout) { should match(%r{flyway.url=jdbc:mysql://localhost/mysql}) }
      its(:stdout) { should match(/flyway.schemas=flywaydb_test/) }
      its(:stdout) { should match(%r{flyway.locations=filesystem:/tmp/db}) }
      its(:stdout) { should match(/flyway.cleanDisabled=true/) }
      its(:stdout) { should match(/flyway.placeholders.test_user=test/) }
    end
  end
end
