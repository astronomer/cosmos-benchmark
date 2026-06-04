{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01510') }},
        {{ ref('model_02214') }}
)
select id, 'model_02681' as name from sources
