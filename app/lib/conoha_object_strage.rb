=begin
コノハのオブジェクトストレージのマッパークラス
挙動で気をつけたいのが、アップロード、ダウンロードするフォルダは、
指定したルートフォルダ以下がオブジェクトストレージと同一の構成であることを前提として動作します。
conoha-ojs(Version: v20150406.1)が必須

# L=/usr/local/bin/conoha-ojs && curl -sL https://github.com/hironobu-s/conoha-ojs/releases/download/v20150406.1/conoha-ojs-linux.amd64.gz | zcat > $L && chmod +x $L
# vi ~/bash_profile
-------------------------------------
PATH=$PATH:$HOME/bin:/usr/local/bin
-------------------------------------
=end
class ConohaObjectStrage
  # 認証情報
  class Auth
    attr_accessor :user_id, :password, :tenant_id, :auth_url, :end_point
  end

  # 認証を行う。
  # 引数のbasepathの子ディレクトリはコンテナ名と一致する必要がある。
  def initialize(auth, basepath)
    if `which conoha-ojs; echo $?`.to_i != 0
      raise 'conoha-ojsがインストールされていません。'
    end

    raise '指定のディレクトリは存在しません。' unless FileTest::directory?(basepath)
    @basepath = basepath.gsub(/\/$/, '')
    @container = File.basename(basepath)
    @container_parent = @container

    message = `conoha-ojs auth -u "#{auth.user_id}" -p "#{auth.password}" -t "#{auth.tenant_id}" -a "#{auth.auth_url}" 2>&1`
    if message.size > 0
      raise "認証に失敗しました。: #{message}"
    end

    @auth = auth
  end

  # 現在のカレントディアを変更する
  def set_dir(dir_path)
    @container_parent = "#{@container}/#{chop_slash(dir_path)}"
  end

  # 設定しているカレントディアに、相対パスでコンテナを作成する。
  # 複数作成したい場合は「container1/container2/container3」のように記載する
  def create_container(container_path)
    raise "コンテナパスが設定されていません。" if container_path.nil? || container_path.size == 0

    container_path = chop_slash(container_path)
    message = `cd "#{@basepath}" && conoha-ojs post -r ".r:*" "#{@container_parent}/#{container_path}" 2>&1`
    # リスティングというフォルア配下を一覧化できる機能を有効かしたい場合は下記。セキュアではない。
    # message = `conoha-ojs post -r ".r:*,.rlistings" "#{container_path}" >&2`
    if message.size > 0
      raise "コンテナ作成に失敗しました。: #{message}"
    end
  end

  # ファイルをアップロードする
  # 引数は設定しているカレントディアに、相対パスでアップロードのパスを記載する。
  def upload(filepath)
    raise "ファイルパスが設定されていません。" if filepath.nil? || filepath.size == 0

    filepath = chop_slash(filepath)
    full_filepath = "#{@basepath}/#{filepath}"

    if File.exist?(full_filepath)
      # 一旦指定のフォルダに遷移するのは、コンテナ名にファイルパスが含められてしまうため。
      message = `cd "#{@basepath}" && conoha-ojs upload "#{@container_parent}" "#{filepath}" >&2`
      if message.size > 0
        raise "アップロードに失敗しました。: #{message}"
      end
    elsif FileTest::directory?(full_filepath)
      # 一旦指定のフォルダに遷移するのは、コンテナ名にファイルパスが含められてしまうため。
      message = `cd "#{@basepath}" && conoha-ojs upload "#{@container_parent}" "#{filepath}" >&2`
      if message.size > 0
        raise "アップロードに失敗しました。: #{message}"
      end
    else
      raise "ファイルが存在しません。: #{full_filepath}"
    end

    "#{@auth.end_point}/#{@container_parent}/#{filepath}"
  end

  # ファイルをダウンロードする
  # FIXME: フォルダを指定した場合に特定のファイルのダウンロードが失敗したらエラーとなるようにする。
  def download(filepath)
    raise "ファイルパスが設定されていません。" if filepath.nil? || filepath.size == 0

    filepath = chop_slash(filepath)

    message = `cd #{File.dirname(@basepath)} && conoha-ojs download "#{@container_parent}/#{filepath}" >&2`
    if message.size > 0
      raise "ダウンロードに失敗しました。: #{message}"
    end

    "#{@basepath}/#{filepath}"
  end

  private
  # 前後のスラッシュを取り除く
  def chop_slash(str)
    str.gsub(/^\//, '').gsub(/\/$/, '')
  end
end

# auth = ConohaObjectStrage::Auth.new
# auth.user_id = "gncuXXXX"
# auth.password = "AsarouRoot0401"
# auth.tenant_id = "7cf6cd6aed604d90a290608b89169504"
# auth.auth_url = "https://identity.tyo1.conoha.io/v2.0"
# auth.end_point = "https://object-storage.tyo1.conoha.io/v1/nc_7cf6cd6aed604d90a290608b89169504"
# conoha_obs = ConohaObjectStrage.new(auth, '/home/app/test/work')
# conoha_obs.create_container('container1')
# puts conoha_obs.upload('container1/aaa.jpeg')
# # puts conoha_obs.upload('container1')
# puts conoha_obs.download('container1/aaa.jpeg')
# # puts conoha_obs.download('container1')
