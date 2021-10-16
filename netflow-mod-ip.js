function process(event) {
  var realSrc = event.Get('netflow.post_nat_source_ipv4_address') || event.Get('netflow.post_nat_source_ipv6_address') || event.Get('source.ip') || event.Get('netflow.source_ipv6_address');
  var realDst = event.Get('netflow.post_nat_destination_ipv4_address') || event.Get('netflow.post_nat_destination_ipv6_address') || event.Get('destination.ip') || event.Get('netflow.destination_ipv6_address');

  if (event.Get('source.ip') !== null) {
    event.Rename('source.ip', 'source.ip_orig');
  }
  event.Put('source.ip', realSrc);

  if (event.Get('destination.ip') !== null) {
    event.Rename('destination.ip', 'destination.ip_orig');
  }
  event.Put('destination.ip', realDst);
}
