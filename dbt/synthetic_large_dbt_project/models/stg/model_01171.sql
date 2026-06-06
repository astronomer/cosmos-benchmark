{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00006') }},
        {{ ref('model_00250') }},
        {{ ref('model_00560') }}
)
select id, 'model_01171' as name from sources
