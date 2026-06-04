{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01567') }},
        {{ ref('model_01724') }}
)
select id, 'model_02788' as name from sources
