// ############################################################################
// ############################################################################
// Code

// ############################################################################
// ############################################################################
// Include files

#include <stdio.h>

#include "bsp.h"
#include "version.h"

// ############################################################################
// ############################################################################
// Function definitions


int main( void )
{
	( void )printf( "Hello world!\n" );
	( void )printf( "Board name: %s!\n", bsp_getName() );
	( void )printf( "Version:    v%s\n", VERSION );

	bsp_init();

	for( int i = 25; i > 0; i-- )
	{
		bsp_led_on();
		bsp_delay( 100000 );
		bsp_led_off();
		bsp_delay( 100000 );
	}

	bsp_led_on();

	/* Will never reach here. Will never return... */
	return 0;
}
