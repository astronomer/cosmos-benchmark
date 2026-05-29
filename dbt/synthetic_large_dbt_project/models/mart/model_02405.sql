{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01925') }},
        {{ ref('model_01695') }}
)
select id, 'model_02405' as name from sources
