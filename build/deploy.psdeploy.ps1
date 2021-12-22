Deploy Module {
    By PSGalleryModule {
        FromSource $ENV:StagingModulePath
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:PSGalleryApiKey
        }
    }
}
