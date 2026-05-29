{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02199') }},
        {{ ref('model_02097') }}
)
select id, 'model_02695' as name from sources
