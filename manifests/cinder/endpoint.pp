#
# shoudl I use this define? It reduces code, but
# obfuscates the way data maps to this interface
#
class kickstack::cinder::endpoint {

  kickstack::endpoint { 'cinder': }

}
