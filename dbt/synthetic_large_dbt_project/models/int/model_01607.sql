{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01391') }},
        {{ ref('model_01092') }},
        {{ ref('model_01006') }}
)
select id, 'model_01607' as name from sources
