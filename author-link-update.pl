#!/usr/local/bin/perl
# $Id$
use strict;
use warnings;

use Template;
use LWP::Simple;
use JSON;

my $tt = Template->new;
my $tmpl = <<'TMPL';
<img src="http://image.profile.livedoor.jp/icon/[% author.author | html %]_16.gif" alt="[% author.name | html %]" border="0" height="16" width="16">&nbsp;<a href="[% author.link | html %]" target="_blank">[% author.name | html %]の記事一覧</a>&nbsp;<a href="[% author.feed | html %]" target="_blank"><img src="http://parts.blog.livedoor.jp/img/cmn/rss_s.gif" alt="[% author.name | html %]の記事一覧のRSSフィード" border="0" height="16" width="16" /></a>&nbsp;<a href="http://reader.livedoor.com/subscribe/[% author.feed | html %]" target="_blank"><img src="http://parts.blog.livedoor.jp/img/cmn/reader_s.gif" alt="[% author.name | html %]の記事一覧のRSSフィードを購読" border="0" height="16" width="16" /></a><br>
TMPL

while (<>) {
    my ($author, $link) = split /\s+/;
    my $json = get(sprintf('http://portal.profile.livedoor.com/api/user/nickname?livedoor_id=%s', $author));
    my $nickname = from_json($json)->{nickname};
    my ($name) = values %$nickname;
    (my $feed = $link) =~ s/\.html/\.xml/;
    my %author = (
        author => $author,
        name  => $name,
        link  => $link,
        feed  => $feed,
    );
    $tt->process(\$tmpl, {author => \%author}, \my $output);
    print $output;
}


__END__

=head1 NAME

author-link-update.pl - 

=head1 SYNOPSIS

  $ perl ./author-link-update.pl < ./authors.txt

=head1 DESCRIPTION

Input file format is:

  author_name author_link
  author_name author_link
  author_name author_link
  ...

=cut

