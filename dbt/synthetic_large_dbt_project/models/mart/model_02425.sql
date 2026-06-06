{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02184') }},
        {{ ref('model_02104') }}
)
select id, 'model_02425' as name from sources
