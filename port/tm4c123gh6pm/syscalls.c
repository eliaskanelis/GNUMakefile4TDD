void _close( void );
void _lseek( void );
void _read( void );
void _write( void );
void _fstat( void );
void _isatty( void );
void *_sbrk( int incr );
void _exit( void );
void _kill( void );
void _getpid( void );



void _close( void )
{
}

void _lseek( void )
{
}

void _read( void )
{
}

void _write( void )
{
}

void _fstat( void )
{
}

void _isatty( void )
{
}

void *_sbrk( int incr )
{
	extern char   end; /* Set by linker.  */
	static char *heap_end;
	char         *prev_heap_end;

	if( heap_end == 0 )
	{
		heap_end = & end;
	}

	prev_heap_end = heap_end;
	heap_end += incr;
	return ( void * ) prev_heap_end;
}

void _exit( void )
{
}

void _kill( void )
{
}

void _getpid( void )
{
}
