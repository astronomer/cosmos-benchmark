{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01372') }},
        {{ ref('model_01397') }}
)
select id, 'model_02242' as name from sources
