{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01424') }},
        {{ ref('model_01288') }},
        {{ ref('model_01015') }}
)
select id, 'model_02078' as name from sources
