####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Droidbattles::BASM::Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 1 "basm.yapp"


my $instructions_re = 
        qr/mov|nop|movsb|movsw|stosb|stosw|lodsb|lodsw|push|pop|xchg|test|cmp|icmp|cmpsb|jmp|jz|jnz|jae|jbe|ja|jb|cj|cjn|lz|lnz|la|lb|lae|lbe|loop|call|ret|iret|cli|sti|out|in|inc|dec|add|sub|and|or|xor|shl|shr|ishl|ishr|ror|rol|int|mul|imul
                |div|idiv
                |sinfunc|cosfunc|atanfunc|sin|cos
                |rnd
                |hwait
                |sqr
                |msg
                |err
                |readfile|writefile/x;

my $compiler_re =
        qr/org|CPUboot|CPUstack|interrupt/;

my $device_re =
        qr/RAM:|DEVICE:/;



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		DEFAULT => -1,
		GOTOS => {
			'input' => 1
		}
	},
	{#State 1
		ACTIONS => {
			'' => 3,
			'COMPINSTRUCT' => 4,
			'LABEL' => 5,
			'COMMENT' => 7,
			'DEVINSTRUCT' => 8,
			'VAR' => 11,
			'error' => 12,
			'INSTRUCT' => 14,
			'ENDLINE' => 16
		},
		GOTOS => {
			'exp' => 2,
			'device_instruction' => 10,
			'declaration' => 9,
			'compiler_instruction' => 13,
			'instruction' => 6,
			'line' => 15
		}
	},
	{#State 2
		ACTIONS => {
			'COMMENT' => 17,
			'ENDLINE' => 18
		}
	},
	{#State 3
		DEFAULT => 0
	},
	{#State 4
		ACTIONS => {
			'NUM' => 20,
			'HEX' => 19
		},
		GOTOS => {
			'numericterm' => 21
		}
	},
	{#State 5
		DEFAULT => -8
	},
	{#State 6
		ACTIONS => {
			'NUM' => 25,
			'HEX' => 22,
			'SYM' => 27,
			"\@" => 23
		},
		DEFAULT => -10,
		GOTOS => {
			'arglist' => 26,
			'term' => 24
		}
	},
	{#State 7
		ACTIONS => {
			'ENDLINE' => 28
		}
	},
	{#State 8
		ACTIONS => {
			'NUM' => 20,
			'HEX' => 19
		},
		GOTOS => {
			'numericterm' => 29,
			'numerictermlist' => 30
		}
	},
	{#State 9
		DEFAULT => -13
	},
	{#State 10
		DEFAULT => -12
	},
	{#State 11
		ACTIONS => {
			'NUM' => 20,
			'HEX' => 19
		},
		GOTOS => {
			'numericterm' => 31
		}
	},
	{#State 12
		ACTIONS => {
			'ENDLINE' => 32
		}
	},
	{#State 13
		DEFAULT => -11
	},
	{#State 14
		DEFAULT => -16
	},
	{#State 15
		DEFAULT => -2
	},
	{#State 16
		DEFAULT => -3
	},
	{#State 17
		ACTIONS => {
			'ENDLINE' => 33
		}
	},
	{#State 18
		DEFAULT => -4
	},
	{#State 19
		DEFAULT => -18
	},
	{#State 20
		DEFAULT => -17
	},
	{#State 21
		DEFAULT => -27
	},
	{#State 22
		DEFAULT => -23
	},
	{#State 23
		ACTIONS => {
			'NUM' => 34,
			'SYM' => 35
		}
	},
	{#State 24
		ACTIONS => {
			"," => 36
		},
		DEFAULT => -14
	},
	{#State 25
		DEFAULT => -22
	},
	{#State 26
		DEFAULT => -9
	},
	{#State 27
		DEFAULT => -21
	},
	{#State 28
		DEFAULT => -6
	},
	{#State 29
		ACTIONS => {
			'NUM' => 20,
			'HEX' => 19
		},
		DEFAULT => -19,
		GOTOS => {
			'numericterm' => 29,
			'numerictermlist' => 37
		}
	},
	{#State 30
		DEFAULT => -28
	},
	{#State 31
		DEFAULT => -26
	},
	{#State 32
		DEFAULT => -7
	},
	{#State 33
		DEFAULT => -5
	},
	{#State 34
		DEFAULT => -25
	},
	{#State 35
		DEFAULT => -24
	},
	{#State 36
		ACTIONS => {
			'NUM' => 25,
			'HEX' => 22,
			'SYM' => 27,
			"\@" => 23
		},
		GOTOS => {
			'arglist' => 38,
			'term' => 24
		}
	},
	{#State 37
		DEFAULT => -20
	},
	{#State 38
		DEFAULT => -15
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'input', 0, undef
	],
	[#Rule 2
		 'input', 2,
sub
#line 24 "basm.yapp"
{ 
                push(@{$_[1]},$_[2]); $_[1] 
        }
	],
	[#Rule 3
		 'line', 1,
sub
#line 29 "basm.yapp"
{ $_[1] }
	],
	[#Rule 4
		 'line', 2,
sub
#line 30 "basm.yapp"
{ $_[1] }
	],
	[#Rule 5
		 'line', 3,
sub
#line 31 "basm.yapp"
{ $_[1] }
	],
	[#Rule 6
		 'line', 2,
sub
#line 32 "basm.yapp"
{}
	],
	[#Rule 7
		 'line', 2,
sub
#line 33 "basm.yapp"
{ $_[0]->YYErrok }
	],
	[#Rule 8
		 'exp', 1,
sub
#line 36 "basm.yapp"
{ print "label @_\n" ; $_[1] ; }
	],
	[#Rule 9
		 'exp', 2,
sub
#line 37 "basm.yapp"
{ print "instruction +arglist @_\n"  ; shift ; [@_]; }
	],
	[#Rule 10
		 'exp', 1,
sub
#line 38 "basm.yapp"
{ print "instruction no args @_\n"; shift ; [@_ ]; }
	],
	[#Rule 11
		 'exp', 1,
sub
#line 39 "basm.yapp"
{ print "compiler instruction, @_\n" ; $_[1]; }
	],
	[#Rule 12
		 'exp', 1,
sub
#line 40 "basm.yapp"
{ print "device instruction @_\n" ; $_[1] ; }
	],
	[#Rule 13
		 'exp', 1,
sub
#line 41 "basm.yapp"
{ print "declaration @_\n" ; $_[1] }
	],
	[#Rule 14
		 'arglist', 1,
sub
#line 44 "basm.yapp"
{ print "TERM\n"; $_[1] }
	],
	[#Rule 15
		 'arglist', 3,
sub
#line 45 "basm.yapp"
{ print "TERM ARGLIST @_\n";  [ $_[1], $_[2] ] }
	],
	[#Rule 16
		 'instruction', 1,
sub
#line 49 "basm.yapp"
{ print "INSTRUCT: @_\n" ; $_[1]; }
	],
	[#Rule 17
		 'numericterm', 1, undef
	],
	[#Rule 18
		 'numericterm', 1,
sub
#line 52 "basm.yapp"
{ print "numericterm @_"; $_[1] }
	],
	[#Rule 19
		 'numerictermlist', 1, undef
	],
	[#Rule 20
		 'numerictermlist', 2,
sub
#line 57 "basm.yapp"
{
              shift;
              warn "numerictermlist @_";
              [  (@_) ];
      }
	],
	[#Rule 21
		 'term', 1, undef
	],
	[#Rule 22
		 'term', 1, undef
	],
	[#Rule 23
		 'term', 1, undef
	],
	[#Rule 24
		 'term', 2, undef
	],
	[#Rule 25
		 'term', 2, undef
	],
	[#Rule 26
		 'declaration', 2,
sub
#line 66 "basm.yapp"
{
                print "VAR numericterm @_\n";
                shift;
                return [@_];
        
        }
	],
	[#Rule 27
		 'compiler_instruction', 2,
sub
#line 74 "basm.yapp"
{ 
        print "COMPINSTR: @_\n";
        push @{ $_[0]->YYData->{code} } , $_[1];
        [ $_[1] , $_[2] ];
}
	],
	[#Rule 28
		 'device_instruction', 2,
sub
#line 82 "basm.yapp"
{ 
        print "DEVINSTRUCT: @_\n";
        my $p = shift;
        if ($_[0] eq 'RAM:') {
                $p->YYData->{ram} = $_[1];
        } else {
                
                push @{ $p->YYData->{devicemap} } , $_[1]
        }
        
        [ @_ ];
   }
	]
],
                                  @_);
    bless($self,$class);
}

#line 97 "basm.yapp"


sub _Error {
        exists $_[0]->YYData->{ERRMSG}
    and do {
        print $_[0]->YYData->{ERRMSG};
        delete $_[0]->YYData->{ERRMSG};
        return;
    };
    print "Syntax error.\n";
}

sub _Lexer {
    my($parser)=shift;

        $parser->YYData->{INPUT}
    or  $parser->YYData->{INPUT} = <STDIN>
    or  return('',undef);

    $parser->YYData->{INPUT}=~s/^[ \t]//;

    for ($parser->YYData->{INPUT}) {
        s/^($instructions_re)//
                and return('INSTRUCT',$1);
        s/^%($compiler_re)//
                and return('COMPINSTRUCT',$1);
        s/^($device_re)//
                and return('DEVINSTRUCT',$1);
        s/^(0x[0-9A-Fa-f]+)//
                and return('HEX',$1);
        s/^([0-9]+(?:\.[0-9]+)?)//
                and return('NUM',$1);
        s/^([A-Za-z][A-Za-z0-9_]*)//
                and return('SYM',$1);
        s/^\$([A-Za-z][A-Za-z0-9_]*)//
                and return('VAR',$1);
        s/^:([A-Za-z][A-Za-z0-9_]*)//
                and return('LABEL',$1);

        s/^\s*;([^\n]+)//
                and return('COMMENT', $1);
        s/^\s*(\n)//
                and return('ENDLINE',$1); 
        s/^(,|@)//
                and return($1,$1);
        
    }
}

sub Run {
    my($self)=shift;
    $self->YYParse( 
        yylex => \&_Lexer, 
        yyerror => \&_Error , 
        yydebug=>0x0,
    );
}

1;
