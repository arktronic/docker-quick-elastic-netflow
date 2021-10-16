function process(event) {
  if (event.Get('source.domain') === null) {
    event.Put('source.domain', event.Get('source.ip'));
  }

  if (event.Get('destination.domain') === null) {
    event.Put('destination.domain', event.Get('destination.ip'));
  }
}
