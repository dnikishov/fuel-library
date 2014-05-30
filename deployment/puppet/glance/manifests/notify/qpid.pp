#
# used to configure qpid notifications for glance
#
class glance::notify::qpid(
  $qpid_password,
  $qpid_username = 'guest',
  $qpid_host     = 'localhosts',
) inherits glance::api {

  glance_api_config {
    'DEFAULT/notifier_strategy': value => 'qpid';
    'DEFAULT/qpid_hosts':         value => $qpid_hosts;
    'DEFAULT/qpid_username':     value => $qpid_username;
    'DEFAULT/qpid_password':     value => $qpid_password;
  }

}
