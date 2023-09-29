function barBuscar(op)
{
	if (op == 1)
		document.getElementById('Busqueda').style.display = 'block';
	else
		document.getElementById('Busqueda').style.display = 'none';
}

function Ayuda(op,tam)
{
	 document.getElementById('ayuda').style.height = tam;
	if (op == 1)
		document.getElementById('ayuda').style.display = 'block';
	else
		document.getElementById('ayuda').style.display = 'none';
}

function Error(op,tam)
{
	 document.getElementById('error').style.height = tam;
	if (op == 1)
		document.getElementById('error').style.display = 'block';
	else
		document.getElementById('error').style.display = 'none';
		
		
}

