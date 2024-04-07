#include <stdint.h>
#include <stddef.h>


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

extern uint8_t end; /* Set by linker.  */
// cppcheck-suppress misra-c2012-8.9
static uint8_t *heap_end = NULL;

void *_sbrk( int incr )
{
	uint8_t *prev_heap_end;

	if( heap_end == NULL )
	{
		heap_end = ( uint8_t * ) &end;
	}

	prev_heap_end = heap_end;
	heap_end += incr;
	return ( void * )prev_heap_end;
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
