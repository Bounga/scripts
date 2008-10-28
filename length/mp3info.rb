# Raised on any kind of error related to ruby-mp3info
class Mp3InfoError < StandardError ; end

class Mp3InfoInternalError < StandardError #:nodoc:
end

class Mp3Info

  VERSION = "0.2"

  LAYER = [ nil, 3, 2, 1]
  BITRATE = [
    [
      [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448],
      [32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384],
      [32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320] ],
    [
      [32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256],
      [8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160],
      [8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160]
    ]
  ]
  SAMPLERATE = [
    [ 44100, 48000, 32000 ],
    [ 22050, 24000, 16000 ]
  ]
  CHANNEL_MODE = [ "Stereo", "JStereo", "Dual Channel", "Single Channel"]

  GENRES = [
    "Blues", "Classic Rock", "Country", "Dance", "Disco", "Funk",
    "Grunge", "Hip-Hop", "Jazz", "Metal", "New Age", "Oldies",
    "Other", "Pop", "R&B", "Rap", "Reggae", "Rock",
    "Techno", "Industrial", "Alternative", "Ska", "Death Metal", "Pranks",
    "Soundtrack", "Euro-Techno", "Ambient", "Trip-Hop", "Vocal", "Jazz+Funk",
    "Fusion", "Trance", "Classical", "Instrumental", "Acid", "House",
    "Game", "Sound Clip", "Gospel", "Noise", "AlternRock", "Bass",
    "Soul", "Punk", "Space", "Meditative", "Instrumental Pop", "Instrumental Rock",
    "Ethnic", "Gothic", "Darkwave", "Techno-Industrial", "Electronic", "Pop-Folk",
    "Eurodance", "Dream", "Southern Rock", "Comedy", "Cult", "Gangsta",
    "Top 40", "Christian Rap", "Pop/Funk", "Jungle", "Native American", "Cabaret",
    "New Wave", "Psychadelic", "Rave", "Showtunes", "Trailer", "Lo-Fi",
    "Tribal", "Acid Punk", "Acid Jazz", "Polka", "Retro", "Musical",
    "Rock & Roll", "Hard Rock", "Folk", "Folk/Rock", "National Folk", "Swing",
    "Fast-Fusion", "Bebob", "Latin", "Revival", "Celtic", "Bluegrass", "Avantgarde",
    "Gothic Rock", "Progressive Rock", "Psychedelic Rock", "Symphonic Rock", "Slow Rock", "Big Band",
    "Chorus", "Easy Listening", "Acoustic", "Humour", "Speech", "Chanson",
    "Opera", "Chamber Music", "Sonata", "Symphony", "Booty Bass", "Primus",
    "Porn Groove", "Satire", "Slow Jam", "Club", "Tango", "Samba",
    "Folklore", "Ballad", "Power Ballad", "Rhythmic Soul", "Freestyle", "Duet",
    "Punk Rock", "Drum Solo", "A capella", "Euro-House", "Dance Hall",
    "Goa", "Drum & Bass", "Club House", "Hardcore", "Terror",
    "Indie", "BritPop", "NegerPunk", "Polsk Punk", "Beat",
    "Christian Gangsta", "Heavy Metal", "Black Metal", "Crossover", "Contemporary C",
    "Christian Rock", "Merengue", "Salsa", "Thrash Metal", "Anime", "JPop",
    "SynthPop" ]

  ID2TAGS = {
    "AENC" => "Audio encryption",
    "APIC" => "Attached picture",
    "COMM" => "Comments",
    "COMR" => "Commercial frame",
    "ENCR" => "Encryption method registration",
    "EQUA" => "Equalization",
    "ETCO" => "Event timing codes",
    "GEOB" => "General encapsulated object",
    "GRID" => "Group identification registration",
    "IPLS" => "Involved people list",
    "LINK" => "Linked information",
    "MCDI" => "Music CD identifier",
    "MLLT" => "MPEG location lookup table",
    "OWNE" => "Ownership frame",
    "PRIV" => "Private frame",
    "PCNT" => "Play counter",
    "POPM" => "Popularimeter",
    "POSS" => "Position synchronisation frame",
    "RBUF" => "Recommended buffer size",
    "RVAD" => "Relative volume adjustment",
    "RVRB" => "Reverb",
    "SYLT" => "Synchronized lyric/text",
    "SYTC" => "Synchronized tempo codes",
    "TALB" => "Album/Movie/Show title",
    "TBPM" => "BPM (beats per minute)",
    "TCOM" => "Composer",
    "TCON" => "Content type",
    "TCOP" => "Copyright message",
    "TDAT" => "Date",
    "TDLY" => "Playlist delay",
    "TENC" => "Encoded by",
    "TEXT" => "Lyricist/Text writer",
    "TFLT" => "File type",
    "TIME" => "Time",
    "TIT1" => "Content group description",
    "TIT2" => "Title/songname/content description",
    "TIT3" => "Subtitle/Description refinement",
    "TKEY" => "Initial key",
    "TLAN" => "Language(s)",
    "TLEN" => "Length",
    "TMED" => "Media type",
    "TOAL" => "Original album/movie/show title",
    "TOFN" => "Original filename",
    "TOLY" => "Original lyricist(s)/text writer(s)",
    "TOPE" => "Original artist(s)/performer(s)",
    "TORY" => "Original release year",
    "TOWN" => "File owner/licensee",
    "TPE1" => "Lead performer(s)/Soloist(s)",
    "TPE2" => "Band/orchestra/accompaniment",
    "TPE3" => "Conductor/performer refinement",
    "TPE4" => "Interpreted, remixed, or otherwise modified by",
    "TPOS" => "Part of a set",
    "TPUB" => "Publisher",
    "TRCK" => "Track number/Position in set",
    "TRDA" => "Recording dates",
    "TRSN" => "Internet radio station name",
    "TRSO" => "Internet radio station owner",
    "TSIZ" => "Size",
    "TSRC" => "ISRC (international standard recording code)",
    "TSSE" => "Software/Hardware and settings used for encoding",
    "TYER" => "Year",
    "TXXX" => "User defined text information frame",
    "UFID" => "Unique file identifier",
    "USER" => "Terms of use",
    "USLT" => "Unsychronized lyric/text transcription",
    "WCOM" => "Commercial information",
    "WCOP" => "Copyright/Legal information",
    "WOAF" => "Official audio file webpage",
    "WOAR" => "Official artist/performer webpage",
    "WOAS" => "Official audio source webpage",
    "WORS" => "Official internet radio station homepage",
    "WPAY" => "Payment",
    "WPUB" => "Publishers official webpage",
    "WXXX" => "User defined URL link frame"
  }

  TAGSIZE = 128
  #MAX_FRAME_COUNT = 6  #number of frame to read for encoder detection

  # mpeg version = 1 or 2
  attr_reader(:mpeg_version)

  # layer = 1, 2, or 3
  attr_reader(:layer)

  # bitrate in kbps
  attr_reader(:bitrate)

  # samplerate in Hz
  attr_reader(:samplerate)

  # channel mode => "Stereo", "JStereo", "Dual Channel" or "Single Channel"
  attr_reader(:channel_mode)

  # variable bitrate => true or false
  attr_reader(:vbr)

  # length in seconds as a Float
  attr_reader(:length)

  # error protection => true or false
  attr_reader(:error_protection)

  # id3v1 tag has a Hash. You can modify it, it will be written when calling
  # "close" method.
  attr_accessor(:tag1)

  # id3v2 tag as a Hash
  attr_reader(:tag2)

  # the original filename
  attr_reader(:filename)

  # Test the presence of an id3v1 tag in file +filename+
  def self.hastag1?(filename)
    File.open(filename) { |f|
      f.seek(-TAGSIZE, File::SEEK_END)
      f.read(3) == "TAG"
    }
  end

  # Test the presence of an id3v2 tag in file +filename+
  def self.hastag2?(filename)
    File.open(filename) { |f|
      f.read(3) == "ID3"
    }
  end


  # Remove id3v1 tag from +filename+
  def self.removetag1(filename)
    if self.hastag1?(filename)
      newsize = File.size(filename) - TAGSIZE
      File.open(filename, "r+") { |f| f.truncate(newsize) }
    end
  end

  # Instantiate a new Mp3Info object with name +filename+
  def initialize(filename)
    $stderr.puts("#{self.class}::new() does not take block; use #{self.class}::open() instead") if block_given?
    raise(Mp3InfoError, "empty file") unless File.stat(filename).size? #FIXME
    @filename = filename
    @vbr = false
    @file = File.new(filename, "rb")
    @tag2 = {}
    @tag1 = gettag1
    @tag_orig = @tag1.dup

    ##########################
    # ID3v2
    ##########################
    tag2_len = 0
    @file.rewind
    if @file.read(3) == "ID3"
      version_maj, version_min, flags = @file.read(3).unpack("CCB4")
      unsync, ext_header, experimental, footer = (0..3).collect { |i| flags[i].chr == '1' }
      @tag2["version"] = "2.#{version_maj}.#{version_min}"
      tag2_len = size_syncsafe(@file.read(4))
      if ext_header
        ext_size = size_syncsafe(@file.read(4)) - 6
        @file.read(2)
        @file.read(ext_size)
      end
      loop do
        break if @file.pos >= tag2_len
        name = @file.read(4)
        #break if name == "\000\000\000\000"
        size = @file.read(4).unpack("N")[0]
        flags = @file.read(2)
        data = @file.read(size)
        type = data[0]
        name = ID2TAGS[name] || name
        if name != "\000\000\000\000"
          @tag2[name] = data[1..-1]
        end
      end
    else
      @file.rewind
    end
    ##########################
    # END OF ID3v2
    ##########################


    begin
      find_frame_sync
      head = @file.read(4)
      raise(Mp3InfoInternalError) if not check_head(head)
      @first_frame_pos = @file.pos - 4
      h = extract_infos_from_head(head)
      h.each { |k,v| eval "@#{k} = #{v.inspect}" }
      seek =
      if @mpeg_version == 3                     # mpeg version 1
        if @channel_num == 3
          15                                    # Single Channel
        else
          30
        end
      else                                      # mpeg version 2 or 2.5
        if @channel_num == 3                    # Single Channel
          7
        else
          15
        end
      end
      @file.pos += seek

      if @file.read(4) == "Xing"                        # This is a VBR file
        @vbr = true
        @file.pos += 4                  #we have the frames number after
        #if @file.read(4).unpack("N")[0] == 0xF
        #end
        @frames = @file.read(4).unpack("N")[0]
        medframe = @file.stat.size / @frames.to_f
        @bitrate = ( (medframe * @samplerate) /  ( 1000 * ( layer==3 ? 12 : 144) ) ).to_i
      end

      @frame_num = 0
      @length = (( (8 * @file.stat.size) / 1000.0) / @bitrate)
    rescue Mp3InfoInternalError
      retry
    rescue
      @file.close
      raise
    end

  end

  # "block version" of Mp3Info::new()
  def self.open(filename)
    m = self.new(filename)
    ret = nil
    if block_given?
      begin
        ret = yield(m)
      ensure
        m.close
      end
    else
      ret = m
    end
    ret
  end

  # Remove id3v1 from mp3
  def removetag1
    if hastag1?
      newsize = @file.stat.size(filename) - TAGSIZE
      @file.truncate(newsize)
      @tag1.clear
    end
    self
  end

  # Has file an id3v1 tag? true or false
  def hastag1?
    ! @tag1.empty?
  end

  # Has file an id3v2 tag? true or false
  def hastag2?
    ! @tag2.empty?
  end

=begin
  def encoder_test
    module ReadBits
      def readbits(nb)
        @reservoir ||= self.getc
        @old_pos ||= self.pos - 1
        @offset ||= 0
        if self.pos != @old_pos + 1
          @reservoir = self.getc
        end
        to_read = (nb+@offset)/8
        @old_pos += to_read
        #$stdout.puts "to_read #{to_read} @offset #{@offset}"
        to_read.times do |i|    #fill up buffer
          n = self.getc
          break if n.nil?
          num = n << (8*(i+1))
          #$stdout.puts "n #{n} num #{num} @offset #{@offset}"
          @reservoir += num
        end
        #$stdout.puts "@reservoir #{@reservoir}"
        ret = (@reservoir >> @offset) & ((2**nb)-1)
        #$stdout.puts "@reservoir end #{@reservoir}"
        if @offset + nb >= 8
          @reservoir = @reservoir >> 8
        end
        @offset = (@offset+nb) % 8
        ret
      end
    end
  =begin
    if __FILE__ == $0
      require "test/unit"
      require "stringio"

      class ReadBitsTest < Test::Unit::TestCase
        NB_TEST = 3

        def group_test(string, a1, a2)
           io = StringIO.new(string*NB_TEST)
           io.extend(ReadBits)
           r1 = (a1*NB_TEST).collect { |i|
             io.readbits(i)
           }
           r2 = a2*NB_TEST
           p r1, r2
           assert(r1 == r2)

        end

        def test_readbits
          group_test("\xa7\xf4", [3, 8, 2, 3], [7, 148, 2, 7])
          group_test("\xa7\xf4", [8, 8], [167, 244])
        end
      end
    end
    =end
    @file.extend(ReadBits)
    @file.pos = @first_frame_pos
    sync_errors = 0
    reservoir_max = 0
    uses_scfsi = false
    MAX_FRAME_COUNT.times do
      begin
        frame_pos = @file.pos
        head = @file.read(4)
        break if head.nil?
        raise(Mp3InfoInternalError, "header error") if not check_head(head)
        frame_infos = extract_infos_from_head(head)
        raise(Mp3InfoInternalError, "layer type error") if frame_infos[:layer] != 3
        raise(Mp3InfoInternalError, "channel mode error '#{frame_infos[:channel_mode]}' found '#{@channel_mode}' expected") if frame_infos[:channel_num] != @channel_num
        raise(Mp3InfoInternalError, "sample rate error") if frame_infos[:samplerate] != @samplerate
        if not frame_infos[:error_protection]
          crc = @file.readbits(16)
          #crc = @file.read(2)
        end
        #usesPadding = frame_infos[:padding]
        if frame_infos[:mpeg_version] & 1 == 1  #mpeg 1
          main_data_begin = @file.readbits(9)
          if @channel_num == 3
            @file.readbits(5)   #private_bits
          else
            @file.readbits(3)   #private_bits
          end
          ((@channel_num == 3 ? 1 : 2)*8).times {       # mono -> 1 channel, stereo -> 2 channels
            uses_scfsi ||= @file.readbits(1) == 1
          }
        else                                    #mpeg 2
          main_data_begin = @file.readbits(8)
          if @channel_num == 3
            @file.readbits(1)   #private_bits
          else
            @file.readbits(2)   #private_bits
          end
        end
        reservoir_max = main_data_begin if main_data_begin > reservoir_max
        $stdout.puts "frame_num #{@frame_num} frame_pos*8 #{frame_pos*8} frame_size #{frame_infos[:size]*8} main_data_begin*8 #{main_data_begin*8} reservoirMax #{reservoir_max} uses_scfsi #{uses_scfsi}"
        #$stdout.puts frame_infos.inspect

        @frame_num += 1
      rescue Mp3InfoInternalError => e
        #$stderr.puts(e.message + " at #{@file.pos}")
        loop do
          @file.pos += 1
          find_frame_sync rescue raise(Mp3InfoError, "sync lost")
          if check_head(@file.read(4))
            @file.pos -= 4
            break
          end
        end
        retry
      end
    end
  end

  def encoder
    "Unknown"
  end
=end

  # Flush pending modifications to tags and close the file
  def close
    return if @file.nil?
    if @tag1 != @tag_orig
      @tag_orig.update(@tag1)
      @file.reopen(@filename, 'rb+')
      @file.seek(-TAGSIZE, File::SEEK_END)
      t = @file.read(3)
      if t != 'TAG'
        #append new tag
        @file.seek(0, File::SEEK_END)
        @file.write('TAG')
      end
      str = [
        @tag_orig["title"]||"",
        @tag_orig["artist"]||"",
        @tag_orig["album"]||"",
        ((@tag_orig["year"] != 0) ? ("%04d" % @tag_orig["year"]) : "\0\0\0\0"),
        @tag_orig["comments"]||"",
        0,
        @tag_orig["tracknum"]||0,
        @tag_orig["genre"]||255
        ].pack("Z30Z30Z30Z4Z28CCC")
      @file.write(str)
    end
    @file.close
    @file = nil
  end

  # inspect inside Mp3Info
  def to_s
<<EOF
id3v1: #{hastag1? && @tag1.inspect} id3v2: #{hastag2? && @tag2.inspect} MPEG #{@mpeg_version} Layer #{@layer} #{@vbr ? "VBR" : "CBR"} #{@bitrate} Kbps \
#{@channel_mode} #{@samplerate} Hz length #{@length} sec. \
error protection #{@error_protection}
EOF
  end

private
  def gettag1
    h = {}
    return h if @file.stat.size < TAGSIZE
    @file.seek(-TAGSIZE, File::SEEK_END)
    if @file.read(3) == "TAG"
      #read id3v1.0 tag
      #@tag1["version"] = "0"
      h["title"],
      h["artist"],
      h["album"],
      year_s,
      h["comments"],
      h["genre"] = @file.read(TAGSIZE - 3).unpack('A30A30A30A4A30C')# accept zero/space padded input
      #read id3v1.1 tag
      if h["comments"][28] == 0
        #@tag1["version"] = "1"
        h["tracknum"] = h["comments"][29].to_i
      end
      ["title", "artist", "album", "comments"].each { |key| h[key].sub!(/\0.*$/, '') }
      year_s.sub!(/\0.*$/, '')
      h["year"] = year_s.to_i
    end
    h
  end

  #########################
  # compute size of 4 bytes
  # with unsync method
  #########################
  def size_syncsafe(bytes)
    c = bytes.unpack("C4")
    c[0]*(0x80**3) +
    c[1]*(0x80**2) +
    c[2]*0x80 +
    c[3]
  end

  def find_frame_sync
    pos = @file.pos
    65536.times do |i|
      @file.pos = pos+i
      str = @file.read(2)
      raise Mp3InfoError if str.nil?
      if str.unpack("B11")[0] == "1"*11
        @file.pos = pos+i
        return
      end
    end
    raise Mp3InfoError
  end

  def check_head(h)
    head = h.unpack("N")[0]
    return false if head & 0xffe00000 != 0xffe00000
    return false if (head >> 17) & 3 == 0
    return false if (head >> 12) & 0xf == 0xf
    return false if (head >> 10) & 0x3 == 0x3
    return false if (head & 0xffff0000) == 0xfffe0000
    bitrate_index = ((head>>12)&0xf)
    lay           = 4-((head>>17)&3)
    return false if lay != 3
    return false if bitrate_index == 0 #free format bitstream
    true
  end

  def extract_infos_from_head(head)
    h = {}
    dummy, a, b, c = head.unpack("C4")
    h[:mpeg_version] = 2 - ((a >> 3) & 1)
    lay = (a >> 1) & 3
    h[:layer] = LAYER[lay]
    raise Mp3InfoInternalError if h[:layer].nil?
    h[:error_protection] = a & 1 == 1
    bitrate = b >> 4
    h[:bitrate] = BITRATE[h[:mpeg_version]-1][h[:layer]-1][bitrate-1] || raise(Mp3InfoInternalError, message)
    srate = (b >> 2) & 3
    h[:samplerate] = SAMPLERATE[h[:mpeg_version]-1][srate] || raise(Mp3InfoInternalError, message)
    h[:padding] = (b >> 1) & 1
    h[:channel_num] = c >> 6 & 3
    h[:channel_mode] = CHANNEL_MODE[h[:channel_num]]
    factor = (h[:layer] == 1 ? 48000 : 144000)/h[:mpeg_version]
    h[:size] = (factor*h[:bitrate])/h[:samplerate] + h[:padding]
    h
  end
end

if $0 == __FILE__
  while filename = ARGV.shift
    begin
      info = Mp3Info.new(filename)
      puts filename
      #puts "MPEG #{info.mpeg_version} Layer #{info.layer} #{info.vbr ? "VBR" : "CBR"} #{info.bitrate} Kbps \
      #{info.channel_mode} #{info.samplerate} Hz length #{info.length} sec."
      puts info
    rescue Mp3InfoError => e
      puts "#{filename}\nERROR: #{e}"
    end
    puts
  end
end
