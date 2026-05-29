{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01564') }},
        {{ ref('model_01518') }}
)
select id, 'model_02612' as name from sources
