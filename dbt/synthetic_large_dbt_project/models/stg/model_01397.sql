{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00607') }},
        {{ ref('model_00279') }},
        {{ ref('model_00659') }}
)
select id, 'model_01397' as name from sources
