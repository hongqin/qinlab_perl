             use strict;
             use Algorithm::Viterbi;
             use Data::Dumper;
 
      my $start_probability = { 'Rainy'=> 0.6, 'Sunny'=> 0.4 };

      my $transition_probability = {
       'Rainy' => {'Rainy'=> 0.7, 'Sunny'=> 0.3},
       'Sunny' => {'Rainy'=> 0.4, 'Sunny'=> 0.6},
      };

      my $emission_probability = {
        'shop' =>  { 'Sunny' => '0.3', 'Rainy' => '0.4' },
        'walk' =>  { 'Sunny' => '0.6', 'Rainy' => '0.1' },
        'clean' => { 'Sunny' => '0.1', 'Rainy' => '0.5' }
      };

      my $v = Algorithm::Viterbi->new();
      $v->start($start_probability);
      $v->transition($transition_probability);
      $v->emission($emission_probability);

      my $observations = [ 'walk', 'walk', 'walk','shop', 'clean','clean','clean' ];

      my ($prob, $v_path, $v_prob) = $v->forward_viterbi($observations);

      my $training_data = [
        [ 'walk', 'Sunny' ],
        [ 'walk', 'Sunny' ],
        [ 'walk', 'Rainy' ],
        [ 'shop', 'Rainy' ],
        [ 'clean', 'Rainy' ],
        [ 'clean', 'Rainy' ],
      ];

      $v->train($training_data);
      my ($prob, $v_path, $v_prob) = $v->forward_viterbi($observations);

	print "#####the path:$v_path\n";
	print "prob = $prob\n";
	print "v_prob = $v_prob\n";
        print Dumper($v);
