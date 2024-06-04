class Nave {
	
	var velocidad
	var direccionRespectoSol
	var combustible
	
	method acelerar(cuanto) { velocidad = (velocidad + cuanto).min(100000) }
	method desacelerar(cuanto) { velocidad = (velocidad - cuanto).max(0) }
	method irHaciaElSol() { direccionRespectoSol = 10 }
	method escaparDelSol() { direccionRespectoSol = -10 }
	method ponerseParaleloAlSol() { direccionRespectoSol = 0 }
	method acercarseUnPocoAlSol() { direccionRespectoSol = if(direccionRespectoSol < 10) direccionRespectoSol + 1 else direccionRespectoSol }
	method alejarseUnPocoDelSol() { direccionRespectoSol = if(direccionRespectoSol > -10) direccionRespectoSol - 1 else direccionRespectoSol }
	method cargarCombustible(cantidad) { combustible = combustible + cantidad }
	method descargarCombustible(cantidad) { combustible = combustible - cantidad }
	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method segundaCondicion()
	method estaTranquila() { return combustible >= 4000 and velocidad <= 12000 and self.segundaCondicion() }
	method escapar()
	method avisar()
	method recibirAmenaza() { 
		self.escapar()
		self.avisar()
	}
	method tienePocaActividad()
	method estaDeRelajo() { return self.estaTranquila() and self.tienePocaActividad() }
	
}

class NaveBaliza inherits Nave {
	
	var colorDeBaliza = "Blanco"
	var cambioColor = false
	
	method cambiarColorDeBaliza(colorNuevo) { 
		colorDeBaliza = colorNuevo
		cambioColor = true
	}
	override method prepararViaje() {
		super()
		colorDeBaliza = "Verde"
		self.ponerseParaleloAlSol()
	}
	override method segundaCondicion() { return colorDeBaliza != "Rojo" }
	override method escapar() { self.irHaciaElSol() }
	override method avisar() { self.cambiarColorDeBaliza("Rojo") }
	override method tienePocaActividad() { return cambioColor }
	
}

class NaveDePasajeros inherits Nave {
	
	const cantidadDePasajeros
	var racionDeComida
	var racionDeBebida
	var racionesDeComidaServidas = 0
	
	method cargarComida(cantidad) { racionDeComida = racionDeComida + cantidad }
	method descargarComida(cantidad) { racionDeComida = 0.max(racionDeComida - cantidad) }
	method cargarBebida(cantidad) { racionDeBebida = racionDeBebida + cantidad }
	method descargarBebida(cantidad) { racionDeBebida = 0.max(racionDeBebida - cantidad) }
	override method prepararViaje() {
		super()
		self.cargarComida(4 * cantidadDePasajeros)
		self.cargarBebida(6 * cantidadDePasajeros)
		self.acercarseUnPocoAlSol()
	}
	override method escapar() { self.acelerar(velocidad * 2) }
	override method avisar() { 
		self.descargarComida(cantidadDePasajeros)
		self.descargarBebida(cantidadDePasajeros * 2)
		racionesDeComidaServidas = racionesDeComidaServidas + cantidadDePasajeros
	}
	override method tienePocaActividad() { return racionesDeComidaServidas < 50 }
	
}

class NaveDeCombate inherits Nave {
	
	var estaInvisible = false
	var misilesDesplegados = false
	const mensajes = []
	
	method ponerseVisible() { estaInvisible = false }
	method ponerseInvisible() { estaInvisible = true }
	method estaInvisible() { return estaInvisible }
	method desplegarMisiles() { misilesDesplegados = true }
	method replegarMisiles() { misilesDesplegados = false }
	method misilesDesplegados() { return misilesDesplegados }
	method emitirMensaje(mensaje) { mensajes.add(mensaje) }
	method mensajesEmitidos() { return mensajes }
	method primerMensajeEmitido() { return mensajes.first() }
	method ultimoMensajeEmitido() { return mensajes.last() }
	method emitioMensaje(mensaje) { return mensajes.contains(mensaje) }
	method esEscueta() { return !mensajes.any({ mensaje => mensaje.length() > 30 }) }
	override method prepararViaje() {
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method segundaCondicion() { return !misilesDesplegados }
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar() { self.emitirMensaje("Amenaza recibida") }
	override method tienePocaActividad() { return self.esEscueta() }
}

class NaveHospital inherits NaveDePasajeros {
	
	var quirofanosPreparados
	
	override method segundaCondicion() { return !quirofanosPreparados }
	override method recibirAmenaza() { 
		super()
		quirofanosPreparados = true
	}
	
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
	
	override method segundaCondicion() { return !estaInvisible }
	override method recibirAmenaza() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
	
}






