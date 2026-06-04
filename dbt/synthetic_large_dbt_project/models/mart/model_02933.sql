{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02184') }},
        {{ ref('model_02090') }},
        {{ ref('model_02052') }}
)
select id, 'model_02933' as name from sources
