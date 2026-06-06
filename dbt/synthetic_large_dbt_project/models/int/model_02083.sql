{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00824') }},
        {{ ref('model_01202') }},
        {{ ref('model_01133') }}
)
select id, 'model_02083' as name from sources
