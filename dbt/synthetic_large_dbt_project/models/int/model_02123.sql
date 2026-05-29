{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01224') }},
        {{ ref('model_01184') }},
        {{ ref('model_01336') }}
)
select id, 'model_02123' as name from sources
