package PneumoDB::Controller::DownloadSequence;
use Moose;
use namespace::autoclean;
use JSON;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use File::Spec;
use File::Basename 'basename';
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

PneumoDB::Controller::DownloadSequence - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# Assembly/Annotation file download
sub downloadSequenceFiles :Path('/download') {
  my ( $self, $c, @args ) = @_;
  # Get post data
  my $postData = from_json $c->request->params->{download_query};


  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->pnu_institution)?$c->user->get('pnu_name'):"GUEST-$c->request->address";

  if(scalar @$postData <= 0) {
    $c->res->body(to_json({'err'=>'No input found!'}));
    return;
  }

  if($args[0]=~/assemblies/) {
    $log_str .= "-AssemblyDownload-". $postData if(scalar @{$postData} > 0);
  }
  elsif($args[0]=~/annotations/) {
    $log_str .= "-AnnotatoionDownload-". $postData if(scalar @{$postData} > 0);
  }
  else {
    $c->res->body({err=>'Bad url!'});
  }


  $c->log->warn($log_str);
  # Get type of url to retrieve - submitted_ftp or fastq_ftp
  my $file_arr = ();
  # For each err id, get the ftp url and store in a hash of arrays
  foreach my $row (@{$postData}) {

    if($args[0]=~/assemblies/) {
      push @$file_arr, File::Spec->catfile($c->config->{download_path}, $row->{study_id}, 'assemblies', $row->{lane_id}.'.contigs_velvet.fa.gz');
    }
    elsif($args[0]=~/annotations/) {
      push @$file_arr, File::Spec->catfile($c->config->{download_path}, $row->{study_id}, 'annotations', $row->{lane_id}.'.gff.gz');
    }
  }
print Dumper $file_arr;
  # Creating a zip file
  my $zip = Archive::Zip->new();
  my $found = 0;
  foreach my $file (@$file_arr) {
    my $file_name = basename $file;
    if(-s "$file") {
      $zip->addFile($file, $file_name, 1);
      $found = 1;
    }
  }
  my $outfilename = "$args[0]_".$c->user->get('pnu_name')."_".time.".zip";
  my $outfile = File::Spec->catfile($c->config->{dataviewer_tmp}, $outfilename);

  if($found == 0) {
    $c->res->body({err=>'Files not available for download!'});
  }
  else {
    # Save the Zip file
    unless ( $zip->writeToFileNamed($outfile) == AZ_OK ) {
      $c->res->body({err=>'Error creating zip file... Please try again!'});
    }
  }

# my $fh = IO::File->new( $outfile, 'r' );

# binmode $fh;

#  use File::stat;
#  my $statObj = stat($outfile);
   $c->res->header('Content-Type' => "text/json");
#   # $c->res->header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
#   $c->res->header('Content-Length' => $statObj->size);
#   $c->res->header('Content-Disposition' => "attachment;filename=$outfilename\n\n");
#   # $c->finalize_headers();
#   $c->res->body( $fh );
  # return json data back to server
  $c->res->body(to_json({'file'=>$outfile}));
}


=encoding utf8

=head1 AUTHOR

Jyothish  N.N.T. Bhai

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
